module salix::demo::basic::Tetris

import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;

alias Model = tuple[int width, int height];

Model startModel = <800, 1200>;

data Msg
   = resizeX(int id, real x)
   | resizeY(int id, real y)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case resizeX(_, real x): m.width = round(x);
       case resizeY(_, real y): m.height = round(y);
       }
     return m;
}

Model init() = startModel;

Figure testFigure(Model m) {
     return tetris();
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        // fig(testFigure(m), width = 600, height = 700);
        fig(extra(), width = 600, height = 700);
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
 
 Figure _tetris1() = 
       circle(lineColor="black", fig=
          grid( borderWidth = 0, borderStyle="groove", vgap=0, hgap= 0// , cellAlign = bottomRight
       , 
       figArray=[
       [place("blue"), emptyFigure()]
      ,[place("blue"), emptyFigure()]
      ,[place("blue"), place("blue")]
       ])
       );
       
Figure emptFigure() = box(size=<10, 10>);
       
Figure _tetris2() = 
       grid(vgap=0, hgap= 0,cellAlign = bottomRight,
       figArray=[
       [emptyFigure(), place("blue")]
      ,[emptyFigure(), place("blue")]
      ,[place("blue"), place("blue")]
       ]);
       
Figure _tetris3() = 
       circle(lineColor="black", lineWidth= 4, fig= grid(vgap=0, hgap= 0 // ,cellAlign = bottomRight
       , figArray=[
       [place("red"), place("red")]
      ,[place("red"), place("red")]
       ]));
    
       
Figure _tetris4() = 
       grid(vgap=0, hgap= 0, cellAlign = bottomRight,
       figArray=[
       [place("yellow"), place("yellow"), place("yellow")]
      ,[emptyFigure(), place("yellow"), emptyFigure()]
       ]);
       
Figure _tetris5() = 
       grid(vgap=0, hgap= 0, cellAlign = bottomRight,
       figArray=[
       [emptyFigure(), place("darkmagenta"), place("darkmagenta")]
      ,[place("darkmagenta"), place("darkmagenta"), emptyFigure()]
       ]);
       
Figure _tetris6() = 
        circle(lineColor="black", lineWidth= 4, fig= grid(vgap=0, hgap= 0
      // ,cellAlign = bottomRight
       , figArray=[
       [place("brown")]
      ,[place("brown")]
      ,[place("brown")]
      ,[place("brown")]
       ]));
       
public Figure tetris() = hcat(borderStyle="ridge", borderWidth = 4, // align = bottomRight,
lineWidth = 1, 
figs=[_tetris1(), _tetris2(),_tetris3(), _tetris4(), _tetris5(), _tetris6()]);

public Figure extra()=ngon(n=4,  angle=PI()/4, grow = sqrt(2.0), align = centerMid, lineWidth=8, lineColor="red", fig = box(lineWidth=6, lineColor="blue", size=<200,100>));
 