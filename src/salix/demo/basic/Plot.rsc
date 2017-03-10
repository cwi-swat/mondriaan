module salix::demo::basic::Plot
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::Slider;


alias Model = list[tuple[int x, int f]];

Model startModel = [<0, 1>, <0, 1>];

data Msg
   = moveX(int id, int x)
   | frek(int id,  int f)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case moveX(int id, int x): m[id].x = x;
       case frek(int id, int f):m[id].f = f;
       }
     return m;
}

Model init() = startModel;


Figure testFigure(Model m) {
     int n  = 25;
     return box(lineWidth=2, lineColor="black", fig=overlay(size=<round(100*2*PI()), 200>, figs=[
       path([p_.M(m[0].x, 0)]+[p_.L(m[0].f*2*PI()*i/n+m[0].x, sin(2*PI()*i/n))|num i<-[1,1+1.0/n..2*n]]
       ,scaleX=100, scaleY=-100, at=<0, 100>, fillColor="none", lineColor="red")
      ,path([p_.M(x, 1)]+[p_.L(m[1].f*2*PI()*i/n+m[1].x, cos(2*PI()*i/n))|num i<-[1,1+1.0/n..2*n]]
       ,scaleX=100, scaleY=-100, at=<0, 100>, fillColor="none", lineColor="blue")
       ]));
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 800, height = 700);  
        slider([[
                  [<moveX, 0, "sin:", 0, 3, 0.5> ]
                 ,[<moveX, 1, "cos:", 0, 3, 0.5> ]
                 ]]);   
        });
    }
    
//---------------------------------------------------------------------------------------------------------------------------------------------------------

App[Model] testApp() {
   return app(init, myView, update, 
    |http://localhost:9103|, |project://salix/src|);
   }
   
public App[Model] c = testApp();

public void main() {
     c.stop();
     c.serve();
     }