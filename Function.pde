PVector VectorRight(){
    return new PVector(1, 0);
}
PVector VectorLeft(){
    return new PVector(-1, 0);
}
PVector VectorUP(){
    return new PVector(0, -1);
}
PVector VectorDown(){
    return new PVector(0, 1);
}

//大きさと角度を入れて正三角形ができる
void easyTriangle(PVector pos, float angle, float size){
    pushMatrix();
        translate(pos.x, pos.y);
        triangle(cos(angle) * size, sin(angle) * size,
                cos(angle + radians(120)) * size, sin(angle + radians(120)) * size,
                cos(angle + radians(240)) * size, sin(angle + radians(240)) * size);
    popMatrix();
}

void easyTriangle(float x, float y, float angle, float size){
    PVector v = new PVector(x, y);
    easyTriangle(v, angle, size);
}

color HSVtoRGB(float h, float s, float v){
    float r = 0, g = 0, b = 0;
    float max = v;
    float min = max - ((s / 255) * max);

    if(h > 360){
        h = h % 360;
    }

    if(h >= 0 && h < 60){
        r = max;
        g = (h / 60) * (max - min) + min;
        b = min;
    }else if(h >= 60 && h < 120){
        r = ((120 - h) / 60) * (max - min) + min;
        g = max;
        b = min;
    }else if(h >= 120 && h < 180){
        r = min;
        g = max;
        b = ((h - 120) / 60) * (max - min) + min;
    }else if(h >= 180 && h < 240){
        r = min;
        g = ((240 - h) / 60) * (max - min) + min;
        b = max;
    }else if(h >= 240 && h < 300){
        r = ((h - 240) / 60) * (max - min) + min;
        g = min;
        b = max;
    }else if(h >= 300 && h < 360){
        r = max;
        g = min;
        b = ((360 - h) / 60) * (max - min) + min;
    }

    return color(r, g, b);
}