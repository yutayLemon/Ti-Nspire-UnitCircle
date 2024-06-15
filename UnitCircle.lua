screen = platform.window;
h = screen:height();
w = screen:width();
InputText = "";
mousePos = {};
mousePos.x = 0;
mousePos.y = 0;
framesPerSecond = 6;
timer.start(1/framesPerSecond);
autoturn = false;
autoturnRate = 0.05;

sinRGB = {R=255,G=0,B=0};
tanRGB = {R=0,G=255,B=0};
cosRGB = {R=0,G=0,B=255};


ExactValues = {
{angle=0,sin="0",cos="1",tan="0"},
{angle=math.pi,sin="0",cos="-1",tan="0"},
{angle=math.pi*(1/2),sin="1",cos="0",tan="undef"},
{angle=math.pi*(3/2),sin="-1",cos="0",tan="undef"},
{angle=math.pi*(1/4),sin="√2/2",cos="√2/2",tan="1"},
{angle=math.pi*(3/4),sin="√2/2",cos="-√2/2",tan="-1"},
{angle=math.pi*(5/4),sin="-√2/2",cos="-√2/2",tan="1"},
{angle=math.pi*(7/4),sin="-√2/2",cos="√2/2",tan="-1"},
{angle=math.pi*(1/3),sin="√3/2",cos="1/2",tan="√3"},
{angle=math.pi*(5/3),sin="-√3/2",cos="1/2",tan="-√3"},
{angle=math.pi*(2/3),sin="√3/2",cos="-1/2",tan="-√3"},
{angle=math.pi*(4/3),sin="-√3/2",cos="-1/2",tan="√3"},
{angle=math.pi*(1/6),sin="1/2",cos="√3/2",tan="1/√3"},
{angle=math.pi*(5/6),sin="1/2",cos="-√3/2",tan="-1/√3"},
{angle=math.pi*(7/6),sin="-1/2",cos="-√3/2",tan="1/√3"},
{angle=math.pi*(11/6),sin="-1/2",cos="√3/2",tan="-1/√3"}
}



--parmeters
xPos = (w/3)*2;
yPos = h/2;
redius = (h*0.5)*0.66;
overShoot = 7;
overText = 6;
lag = 0.015;--radias delay when on important point
angle = 0;

function DrawUnitCircle(gc)
    --draw circle itself
    
    redius = (h*0.5)*0.66;
    gc:drawArc(xPos-(redius),yPos-(redius),redius*2,redius*2,0,360);
    plotPoint(gc,xPos,yPos);
    
    
    redius = (h*0.5)*0.66+overShoot;
    --draw the exct value lines,precomputed
    gc:setPen("thin","dashed");
    
    gc:drawLine(xPos,yPos,xPos+(redius),yPos);--0
    gc:drawString("0",xPos+1.4*overText+redius,yPos-1.4*overText);
    gc:drawLine(xPos,yPos,xPos-(redius),yPos);--pi
    gc:drawString("π",xPos-redius-1.4*overText,yPos-1.4*overText);
    gc:drawLine(xPos,yPos,xPos,yPos+(redius));--1/2 pi
    gc:drawString("π/2",xPos-1.4*overText,yPos-1.4*overText-redius);
    gc:drawLine(xPos,yPos,xPos,yPos-(redius));--3/2 pi
    gc:drawString("3π/2",xPos-1.4*overText,yPos-1.4*overText+redius);
    
    gc:drawLine(xPos,yPos,xPos+(0.707*redius),yPos+(-0.707*redius));--1/4 pi
    gc:drawString("π/4",xPos+(0.707*(redius+overText))-1.4*overText,yPos+(-0.707*(redius+overText))-1.4*overText);
    gc:drawLine(xPos,yPos,xPos+(-0.707*redius),yPos+(-0.707*redius));--3/4 pi
    gc:drawString("3π/4",xPos+(-0.707*(redius+overText))-1.4*overText,yPos+(-0.707*(redius+overText))-1.4*overText);
    gc:drawLine(xPos,yPos,xPos+(-0.707*redius),yPos+(0.707*redius));--5/4 pi
    gc:drawString("5π/4",xPos+(-0.707*(redius+overText))-1.4*overText,yPos+(0.707*(redius+overText))-1.4*overText);
    gc:drawLine(xPos,yPos,xPos+(0.707*redius),yPos+(0.707*redius));--7/4 pi
    gc:drawString("7π/4",xPos+(0.707*(redius+overText))-1.4*overText,yPos+(0.707*(redius+overText))-1.4*overText);
    
    gc:drawLine(xPos,yPos,xPos+(0.5*redius),yPos+(-0.866*redius));--1/3 pi
    gc:drawString("π/3",xPos+(0.5*(redius+overText))-1.4*overText,yPos+(-0.866*(redius+overText))-1.4*overText);
    gc:drawLine(xPos,yPos,xPos+(0.5*redius),yPos+(0.866*redius));--5/3 pi
    gc:drawString("5π/3",xPos+(0.5*(redius+overText))-1.4*overText,yPos+(0.866*(redius+overText))-1.4*overText);
    gc:drawLine(xPos,yPos,xPos+(-0.5*redius),yPos+(-0.866*redius));--2/3 pi
    gc:drawString("2π/3",xPos+(-0.5*(redius+overText))-1.4*overText,yPos+(-0.866*(redius+overText))-1.4*overText);
    gc:drawLine(xPos,yPos,xPos+(-0.5*redius),yPos+(0.866*redius));--4/3 pi
    gc:drawString("4π/3",xPos+(-0.5*(redius+overText))-1.4*overText,yPos+(0.866*(redius+overText))-1.4*overText);

        
    gc:drawLine(xPos,yPos,xPos+(0.866*redius),yPos+(-0.5*redius));--1/6 pi
    gc:drawString("π/6",xPos+(0.866*(redius+overText))-1.4*overText,yPos+(-0.5*(redius+overText))-1.4*overText);
    gc:drawLine(xPos,yPos,xPos+(-0.866*redius),yPos+(-0.5*redius));--5/6 pi
    gc:drawString("5π/6",xPos+(-0.866*(redius+overText))-1.4*overText,yPos+(-0.5*(redius+overText))-1.4*overText);
    gc:drawLine(xPos,yPos,xPos+(-0.866*redius),yPos+(0.5*redius));--7/6 pi
    gc:drawString("7π/6",xPos+(-0.866*(redius+overText))-1.4*overText,yPos+(0.5*(redius+overText))-1.4*overText);
    gc:drawLine(xPos,yPos,xPos+(0.866*redius),yPos+(0.5*redius));--11/6 pi
    gc:drawString("11π/6",xPos+(0.866*(redius+overText))-1.4*overText,yPos+(0.5*(redius+overText))-1.4*overText);
   
    gc:setPen("thin","smooth");
        
end

function updateAngle()
    if(autoturn)then
        angle = angle+autoturnRate;
        angle = angle %(math.pi*2);
    else
    angle = math.atan(-(mousePos.y-yPos)/(mousePos.x-xPos));
    if(angle < 0 and xPos <= mousePos.x)then--4th qudrent
        angle = (2*math.pi) + angle;
    elseif(angle < 0) then--2nd qutial
        angle = math.pi+angle;
    elseif(angle >= 0 and xPos > mousePos.x)then
        angle = angle + (math.pi);--3rth
    end
    end
    for i=1,#ExactValues do
            if(angle >= (ExactValues[i].angle-(math.pi*lag)+math.pi*2)%(math.pi*2) and angle <= (ExactValues[i].angle+(math.pi*lag)+math.pi*2)%(math.pi*2)) then
                angle = ExactValues[i].angle;
            end
     end
end
function drawUserPoint(gc)
    
    --print(angle);
    local xEnd = math.cos(angle)*(redius);
    local yEnd = math.sin(angle)*(redius);
   
    xEnd = xPos + xEnd;--center at origin
    yEnd = yPos - yEnd;
   
    gc:drawLine(xPos,yPos,xEnd,yEnd);
    gc:drawArc(xEnd-2,yEnd-2,4,4,0,360);
    
    --draw sin and cos,tan lines
    gc:setColorRGB(cosRGB.R,cosRGB.G,cosRGB.B);
    gc:drawLine(xPos,yEnd,xEnd,yEnd);--cos
    gc:setColorRGB(sinRGB.R,sinRGB.G,sinRGB.B);
    gc:drawLine(xEnd,yPos,xEnd,yEnd);--sin
    gc:setColorRGB(0,0,0);
    local factor = angle/math.pi;
    local exact = false;
    local sinstr = "";
    local cosstr = "";
    for i=1,#ExactValues do
       if((math.floor(angle*100+0.5)/100) == (math.floor(ExactValues[i].angle*100+0.5)/100))then
            exact = true;
            sinstr="sin:"..ExactValues[i].sin;
            cosstr = "cos:"..ExactValues[i].cos;
        end
     end
        if(not exact)then
                   sinstr=("sin:"..(math.floor((math.sin(angle)/math.pi)*100+0.5)/100).."π");
                   cosstr=("cos:"..(math.floor((math.cos(angle)/math.pi)*100+0.5)/100).."π");
                   
        end
    gc:setColorRGB(cosRGB.R,cosRGB.G,cosRGB.B);
    gc:drawString(cosstr,(xPos+xEnd)/2,yEnd);--midpoits
    gc:setColorRGB(sinRGB.R,sinRGB.G,sinRGB.B);
    gc:drawString(sinstr,xEnd,(yPos+yEnd)/2);--midpoints 
    gc:setColorRGB(0,0,0);
    
end

function drawGraph(gc,x,y,func,wid,hei,R,G,B)
    gc:setColorRGB(R,G,B);
    local BoxHight = hei;
    local BoxWidth = wid;
    --gc:drawRect(x,y,BoxWidth,BoxHight);
    local last = {0,(0.4)*BoxHight*(-1)*func(0)};
    local incraments = BoxWidth;
    for i=1,incraments do
        local newY = (0.4)*BoxHight*(-1)*func((i/incraments)*math.pi*2);
             gc:drawLine(last[1]+x,last[2]+y+BoxHight/2,last[1]+x+1,newY+y+BoxHight/2);--negative 1 as y is positive down
               last = {last[1]+1,newY};
       
    end
    gc:setColorRGB(0,0,0);
    gc:drawLine(x,BoxHight*0.5+y,x+BoxWidth,y+0.5*BoxHight)
    newY = -0.5+(0.4)*BoxHight*(-1)*func(((angle/(math.pi*2)))*math.pi*2)
    gc:drawArc(x+(angle/(math.pi*2))*BoxWidth-2,newY+y+BoxHight/2-2,4,4,0,360);
    
end

function drawTan(gc,x,y,wid,hei,R,G,B)
    gc:setColorRGB(R,G,B);
    local BoxHight = hei;
    local BoxWidth = wid;
    --gc:drawRect(x,y,BoxWidth,BoxHight);
    local last = {0,(0.4)*BoxHight*(-1)*math.tan(0)};
    local incraments = BoxWidth;
    for i=1,incraments do
        local newY = (0.4)*BoxHight*(-1)*math.tan((i/incraments)*math.pi*2)*0.1;
        if(math.abs(newY) > hei/2)then
             newY=last[2];
        end
        
        
        if(math.abs(last[2] - newY)>hei/3)then
            gc:setColorRGB(0,0,0);
            gc:setPen("thin","dashed");--asymtopes
        end     
        gc:drawLine(last[1]+x,last[2]+y+BoxHight/2,last[1]+x+1,newY+y+BoxHight/2);--negative 1 as y is positive down
        last = {last[1]+1,newY};
        gc:setPen("thin");
        gc:setColorRGB(tanRGB.R,tanRGB.G,tanRGB.B);

            
            
       
    end
    gc:setColorRGB(0,0,0);
    gc:drawLine(x,BoxHight*0.5+y,x+BoxWidth,y+0.5*BoxHight)
    newY = -0.5+(0.4)*BoxHight*(-1)*math.tan(((angle/(math.pi*2)))*math.pi*2)*0.1;
      if(math.abs(newY) > hei/2)then
               newY=0;
          end
    
    gc:drawArc(x+(angle/(math.pi*2))*BoxWidth-2,newY+y+BoxHight/2-2,4,4,0,360);--dot
    
end


function drawInfo(gc)
    local chunk = h/20;
    local chunkw = w/20;
    local factor = angle/math.pi;
    local exact = false;
    for i=1,#ExactValues do
        if((math.floor(angle*100+0.5)/100) == (math.floor(ExactValues[i].angle*100+0.5)/100))then
            exact = true;
            gc:setColorRGB(sinRGB.R,sinRGB.G,sinRGB.B);
            gc:drawString("sin:"..ExactValues[i].sin,chunkw,chunk*5);
            gc:setColorRGB(cosRGB.R,cosRGB.G,cosRGB.B);
            gc:drawString("cos:"..ExactValues[i].cos,chunkw,chunk*10);
            gc:setColorRGB(tanRGB.R,tanRGB.G,tanRGB.B);
            gc:drawString("tan:"..ExactValues[i].tan,chunkw,chunk*15);
        end
    end
    if(not exact)then
                gc:setColorRGB(sinRGB.R,sinRGB.G,sinRGB.B);
               gc:drawString("sin:"..(math.floor((math.sin(angle)/math.pi)*100+0.5)/100).."π",chunkw,chunk*5);
               gc:setColorRGB(cosRGB.R,cosRGB.G,cosRGB.B);
               gc:drawString("cos:"..(math.floor((math.cos(angle)/math.pi)*100+0.5)/100).."π",chunkw,chunk*10);
               gc:setColorRGB(tanRGB.R,tanRGB.G,tanRGB.B);
               gc:drawString("tan:"..(math.floor((math.tan(angle)/math.pi)*100+0.5)/100).."π",chunkw,chunk*15);
    end
    gc:setColorRGB(0,0,0);
    gc:drawString("radians:"..(math.floor(factor*100+0.5)/100).."π",chunkw,chunk);
    gc:drawString("degrees:"..math.floor(math.deg(angle)).."º",chunkw,chunk*2);
    
     drawGraph(gc,10,chunk*6,math.sin,70,chunk*3,sinRGB.R,sinRGB.G,sinRGB.B);
     drawGraph(gc,10,chunk*11,math.cos,70,chunk*3,cosRGB.R,cosRGB.G,cosRGB.B);
     drawTan(gc,10,chunk*16,70,chunk*4,tanRGB.R,tanRGB.G,tanRGB.B);
end

function plotPoint(gc,x,y)
    gc:drawRect(x,y,1,1);
end

function vectAdd(vect1,vect2)
    local temp = {};
    temp.x = vect1.x + vect2.x;
    temp.y = vect1.y + vect2.y;
    return temp;
end
function vectMult(Scal,Vect)
    local temp = {};
    temp.x = Scal * Vect.x;
    temp.y = Scal * Vect.y
    return temp
end
function on.paint(gc)

    gc:setFont("sansserif","i",6);
    updateAngle();
    local chunk = h/20;
    local chunkw = w/20;
    gc:setColorRGB(255,100,0);
    gc:drawString("press (a) to auto rotate",chunkw*10,chunk*18);
    gc:setColorRGB(0,0,0);
    DrawUnitCircle(gc);
    drawUserPoint(gc);
    drawInfo(gc);
end

















function on.timer()
    screen:invalidate();
end

function on.charIn(char)
    if(char == "a")then
        autoturn = true;
    end
end

function on.resize(width,height)
    h = height;
    w = width;
end

function on.backspaceKey()
    InputText = string.sub(InputText,1,string.len(InputText) -1);
end

function on.mouseMove(x,y)
    autoturn = false;
    mousePos.x = x;
    mousePos.y = y;
end
