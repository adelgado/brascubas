/* cam.js - A lightweight wrapper to simplify Javascript camera capture :)

  Copyright (C) 2013 Theodore Surgent

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/

//Normalize out vendor prefixes
window.requestAnimationFrame = window.requestAnimationFrame || 
                               window.webkitRequestAnimationFrame || 
                               window.mozRequestAnimationFrame;
window.URL = window.URL || window.webkitURL;
navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || 
                         navigator.mozGetUserMedia;

//Camera
cam = {};

/**
* Checks if camera capture is plausible
* @return true if camera capture is plausible, false otherwise
*/
cam.supported = function() {
    return typeof(navigator.getUserMedia) != "undefined";
}

/**
* Gets an object url representing a camera stream for use as the src of <video> elements or null on error
* @param callback Will be called with and when parameters `url` and `stream` are ready
*/
cam.media = function(callback) {
    if(!cam.supported()) {
        callback(null, null);
        return;
    }

    navigator.getUserMedia(
        {video:true, audio:false},
        function(stream) {
            try { //Chrome and Firefox
                var oUrl = window.URL.createObjectURL(stream);
                callback(oUrl, stream);
            }
            catch(err) { //Older Firefox and Opera
                callback(stream, stream);
            }   
        },
        function(err) { callback(null, null); });
}

/**
* Gets a <video> DOM element with a camera attached as the video source or null on error
* @param callback Will be called with and when parameters `video`, `url`, and `stream` are ready
*/
cam.video = function(callback) {
    if(!cam.supported()) {
        callback(null, null, null);
        return;
    }

    var video = document.createElement("video");

    cam.media(function(oUrl, stream) {
        if(oUrl == null || stream == null)
            callback(null, null, null);

        //Firefox 18 uses mozSrcObject
        video.src = video.mozSrcObject = oUrl;

        //loadeddata does not fire on Firefox 20!
        if(navigator.userAgent.indexOf("Firefox/20") > 0)
            video.addEventListener('loadedmetadata', function() { callback(video, oUrl, stream); });
        else
            video.addEventListener('loadeddata', function() { callback(video, oUrl, stream); });
    });
}

/**
* Opens the camera, gets an <img> DOM element from it or null on error and closes the camera
* @param callback Will be called with parameter `img` once an <img> DOM element is captured
*/
cam.image = function(callback) {
    var cap = new cam.Capture();

    cap.start(function() {
        var img = cap.captureImage();
        cap.stop();
        callback(img);
    });
}

/**
* Capture class for rapidly capturing multiple frames from the camera
*/
cam.Capture = function() {
    var video = null;
    var oUrl = null;
    var stream = null;
    var canvas = null;
    var ctx = null;
    var _this = this;

    function started() {
        return video != null && oUrl != null && stream != null;
    }

    function grabFrame() {
        if(!started())
            return;

        //this.captureContext2d() does not call grabFrame() so we try to avoid the extra
        //canvas overhead associated with it by not creating one in this.start()
        if(!canvas) {
            canvas = document.createElement("canvas");
            ctx = canvas.getContext("2d");
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
        }

        var width = arguments.length == 2 ? arguments[0] : video.videoWidth;
        var height = arguments.length == 2 ? arguments[1] : video.videoHeight;

        ctx.clearRect(0, 0, width, height);
        ctx.drawImage(video, 0, 0, width, height);
    }

    function waitFirstFrame(callback) {
        //Firefox 18-19 got things right
        if(navigator.userAgent.indexOf("Chrome") < 0 && 
           navigator.userAgent.indexOf("Opera") < 0 &&
           !/Firefox\/2[01]/.test(navigator.userAgent) ) {
            callback(_this);
            return;
        }

        //Create a canvas to sample pixels from
        var ctx;
        if(arguments.length == 2)
            ctx = arguments[1];
        else {
            var canvas = document.createElement("canvas");
            //Sample a 4x4 grid (arbitrarily chosen)
            canvas.width = 4;
            canvas.height = 4;
            ctx = canvas.getContext("2d");
        }

        //Firefox 20-21 likes to throw "Component is not available"
        try {
            _this.captureContext2d(ctx);
        }
        catch(ex) {
            setTimeout(function() {
                waitFirstFrame(callback, ctx);
            }, 50);
            return;
        }

        var idata = ctx.getImageData(0, 0, 4, 4);
        var data = idata.data;

        //Sample pixels to see if we have a frame yet
        for(var i = 0; i < 16; ++i) {
            //Skip alpha channel
            if(data[i * 4] + data[i * 4 + 1] + data[i * 4 + 2] > 0) {
                callback(_this);
                return;
            }
        }

        //No frame yet, try again in a little bit
        setTimeout(function() {
            waitFirstFrame(callback, ctx);
        }, 50);
    }
    
    /**
    * Starts a capturing session
    * @param callback Will be called with this object as a parameter when the camera is ready or null on error
    */
    this.start = function(callback) {
        cam.video(function(videoArg, oUrlArg, streamArg) {
            //Already started!
            if(started())
                callback(_this);
                
            //Failed to initialize :(
            if(videoArg == null || oUrlArg == null || streamArg == null)
                callback(null);
        
            video = videoArg;
            oUrl = oUrlArg;
            stream = streamArg;
            video.play();

            waitFirstFrame(callback);
        });
    }
    
    /**
    * Stops a capturing session
    */
    this.stop = function() {
        canvas = null;
        ctx = null;
        video.pause();
        video = null;
        oUrl = null;
        //No `LocalMediaStream.stop()` on Opera!?
        if(typeof(stream.stop) != "undefined")
            stream.stop();
        stream = null;
    }
    
    /**
    * Gets the capture width
    * @return The width of the capture frame in pixels or null on error
    */
    this.width = function() {
        if(!started())
            return null;
            
        return video.videoWidth;
    }
    
    /**
    * Gets the capture height
    * @return The height of the capture frame in pixels or null on error
    */
    this.height = function() {
        if(!started())
            return null;
            
        return video.videoHeight;
    }
    
    /**
    * Captures a frame and formats it as a base64 encoded png image file
    * @return a base64 encoded png image file or null on error
    */
    this.captureDataURL = function() {
        if(!started())
            return null;
            
        grabFrame();
        return canvas.toDataURL("image/png");
    }
    
    /**
    * Captures a frame and creates an <img> DOM element from it
    * @return an <img> DOM element or null on error
    */
    this.captureImage = function() {
        var dataURL = this.captureDataURL();

        //Error :(
        if(!dataURL)
            return null;
        
        var image = new Image();
        image.src = dataURL;
        return image;
    }
    
    /**
    * Captures a frame and draws it on to a canvas (stretched to fit)
    * @param context2d The 2d context used to draw the image on to a canvas
    */
    this.captureContext2d = function(context2d) {
        if(!(started() && context2d))
            return;

        var width = context2d.canvas.width;
        var height = context2d.canvas.height;
        context2d.drawImage(video, 0, 0, width, height);
    }
    
    /**
    * Captures a frame as an ImageData object
    * @param width Width of the ImageData object, where 0 < width <= width()
    * @param height Height of the ImageData object, where 0 < height <= height()
    * @return an ImageData object or null on error
    */
    this.captureImageData = function(width, height) {
        if(!started() || width < 1 || width > this.width() || height < 1 || height > this.height())
            return null;
            
        grabFrame(width, height);
        return ctx.getImageData(0, 0, width, height);
    }
}
