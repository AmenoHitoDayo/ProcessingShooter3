//FPS計測(1フレーム目から積立でやってるから、正確には違うかもしれない。)

class FPSChecker{
    long beginTime = System.currentTimeMillis();

    int getFPS(){
        long nowTime = System.currentTimeMillis();
        int nowFrame = frameCount;
        double time = (nowTime - beginTime) / 1000;
        if(time > 1){
            double FPS = nowFrame / time;
            return (int)FPS;
        }else{
            return 0;
        }
    }
}