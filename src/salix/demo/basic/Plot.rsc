module salix::demo::basic::Plot
import util::Math;
import shapes::Figure;
import salix::HTML;
import salix::Core;
import salix::App;
import salix::LayoutFigure;
import salix::Slider;


alias Model = list[tuple[num x, num f]];

Model startModel = [<0, 1>, <0, 1>];

data Msg
   = moveX(int id, real x)
   | frek(int id,  real f)
   ;
   
 Model update(Msg msg, Model m) {
    switch (msg) {
       case moveX(int id, real x): m[id].x = x;
       case frek(int id, real f):m[id].f = f;
       }
     return m;
}

Model init() = startModel;


Figure testFigure(Model m) {
     int n  = 20;
     return vcat(vgap=10, width = round(100*2*PI()), figs=[
       box(lineWidth=2, lineColor="black",  fig=overlay(size=<round(100*2*PI()), 210>, figs=[
       path([p_.M(0, sin(m[0].x))]+[p_.L(m[0].f*2*PI()*i/n, sin(2*PI()*(i/n)+m[0].x))|num i<-[1, 2..n+1]]
       ,scaleX=100, scaleY=-100, at=<0, 105>, fillColor="none", lineColor="red", midMarker=circle(r=3, fillColor="black"))
       ,path([p_.M(0, cos(m[1].x))]+[p_.L(m[1].f*2*PI()*i/n, cos(2*PI()*(i/n)+m[1].x))|num i<-[1,2..n+1]]
       ,scaleX=100, scaleY=-100, at=<0, 105>, fillColor="none", lineColor="blue", midMarker=box(size=<6, 6>, lineColor="black"))
       ]))
       , hcat(height=30,  /*width = round(100*2*PI()),*/ align = topLeft, hgap=0, figs=[
              box(fig=htmlText("sin: x=<m[0].x>", fontColor="red"), lineColor="black"), box(fig=htmlText("cos: x=<m[1].x>", fontColor="blue"), lineColor="black")])
       ]);
     }
     
void myView(Model m) {
    div(() {
        h2("Figure using SVG");
        fig(testFigure(m), width = 800, height = 350);  
        slider([[
                  [<moveX, 0, "sin:", 0, 3.14, 0.1, 0> ]
                 ,[<moveX, 1, "cos:", 0, 3.14, 0.1, 0> ]
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