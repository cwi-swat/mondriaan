module salix::demo::basic::Tetris

import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::Slider;

alias Model = list[tuple[num phi]];

Model startModel = [<0>, <0>, <0>, <0>, <0>, <0>];

data Msg
   = angle(int id, real phi)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case angle(int id, real phi): m[id].phi = phi;
       }
     return m;
}

Model init() = startModel;


Figure testFigure(Model m) {
     return extra();
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 600, height = 700);
        // fig(tetris(m), width = 800, height = 200);
        list[list[list[SliderBar]]] sliderBars = [[[<angle, i, "<i+1> angle:", 0, 2*PI(), PI()/64, m[i].phi,"0", "2pi"> ]]|i<-[0..6]];
        slider(sliderBars);   
        });
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------

App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://mondriaan/src|);
   }
   
public App[Model] c = testApp();

public void main() {
     c.stop();
     c.serve();
     }
     
 Figure place(str fill) = box(size=<25, 25>, lineColor="grey", fillColor = fill);
 
 Figure _tetris1(Model m) = 
       rotate(m[0].phi,
          grid( borderWidth = 0, borderStyle="groove", vgap=0, hgap= 0// , cellAlign = bottomRight
       , 
       figArray=[
       [place("blue"), emptyFigure()]
      ,[place("blue"), emptyFigure()]
      ,[place("blue"), place("blue")]
       ]),lineColor="black", lineWidth=2
       );
       
Figure emptFigure() = box(size=<10, 10>);
       
Figure _tetris2(Model m) = 
       rotate(m[1].phi,grid(vgap=0, hgap= 0,
       figArray=[
       [emptyFigure(), place("blue")]
      ,[emptyFigure(), place("blue")]
      ,[place("blue"), place("blue")]
       ]));
       
Figure _tetris3(Model m) = 
       rotate(m[2].phi, grid(vgap=0, hgap= 0
       , figArray=[
       [place("red"), place("red")]
      ,[place("red"), place("red")]
       ]));
    
      
Figure _tetris4(Model m) = 
       rotate(m[3].phi,grid(vgap=0, hgap= 0,figArray = [
       [place("yellow"), place("yellow"), place("yellow")]
      ,[emptyFigure(), place("yellow"), emptyFigure()]
       ]));
       
Figure _tetris5(Model m) = 
       rotate(m[4].phi,grid(vgap=0, hgap= 0, figArray = [
       [emptyFigure(), place("darkmagenta"), place("darkmagenta")]
      ,[place("darkmagenta"), place("darkmagenta"), emptyFigure()]
       ]));
       
Figure _tetris6(Model m) = 
        rotate(m[5].phi,
       grid (figArray=[
       [place("brown")]
      ,[place("brown")]
      ,[place("brown")]
      ,[place("brown")]
      ]
       ));
       
public Figure tetris(Model m) = hcat(borderStyle="ridge", borderWidth = 4, // align = bottomRight,
// lineWidth = 1, 
figs=[_tetris1(m), _tetris2(m),_tetris3(m), _tetris4(m), _tetris5(m), _tetris6(m)]);

public Figure extra()=// ngon(n=4,  angle=PI()/4, grow = sqrt(2.0), align = centerMid, lineWidth=8, lineColor="red", fig = 
  //  box(lineWidth=6, lineColor="blue", size=<200,100>));
    

      // circle(lineWidth=16, lineColor="gold", fig=hcat(borderWidth=0, lineWidth = 0, size=<150,100>, figs=[box(lineColor="red", lineWidth=8)]));
      circle(lineWidth=16, grow=1.0, lineColor="gold", fig = box(size=<150,100>,lineColor="red", lineWidth=8));
    
    
    
    
 