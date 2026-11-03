PRAGMA foreign_keys = ON;
-- =====================================================
-- BlenderSchool – SQL database (SQLite, runs in the browser)
-- js/db.js runs this file on the first visit. MySQL version: php/database.sql
-- =====================================================



DROP TABLE IF EXISTS komentar;
DROP TABLE IF EXISTS objava;
DROP TABLE IF EXISTS napredek;
DROP TABLE IF EXISTS lekcija;
DROP TABLE IF EXISTS modul;
DROP TABLE IF EXISTS bliznjica;
DROP TABLE IF EXISTS uporabnik;

-- Users (the password is stored only as a hash, never as plain text)
CREATE TABLE uporabnik (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    uporabnisko_ime VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    geslo_hash VARCHAR(255) NOT NULL,
    datum_registracije DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Modules (groups of lessons)
CREATE TABLE modul (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    naslov VARCHAR(100) NOT NULL,
    opis TEXT,
    vrstni_red INT NOT NULL DEFAULT 0
);

-- Lessons inside a module
CREATE TABLE lekcija (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_modula INT NOT NULL,
    naslov VARCHAR(150) NOT NULL,
    vsebina TEXT NOT NULL,
    slika_gif VARCHAR(255) NULL,
    vrstni_red INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_modula) REFERENCES modul(id) ON DELETE CASCADE
);

-- Progress: one row = one completed lesson
CREATE TABLE napredek (
    id_uporabnika INT NOT NULL,
    id_lekcije INT NOT NULL,
    datum_dokoncanja DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_uporabnika, id_lekcije),
    FOREIGN KEY (id_uporabnika) REFERENCES uporabnik(id) ON DELETE CASCADE,
    FOREIGN KEY (id_lekcije) REFERENCES lekcija(id) ON DELETE CASCADE
);

-- Shortcuts for the cheat sheet
CREATE TABLE bliznjica (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tipka VARCHAR(50) NOT NULL,
    opis VARCHAR(255) NOT NULL,
    kategorija VARCHAR(50) NOT NULL
);

-- Gallery posts (images of finished work)
CREATE TABLE objava (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_uporabnika INT NOT NULL,
    id_modula INT NOT NULL,
    pot_do_slike VARCHAR(255) NOT NULL,
    besedilo TEXT,
    datum DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_uporabnika) REFERENCES uporabnik(id) ON DELETE CASCADE,
    FOREIGN KEY (id_modula) REFERENCES modul(id) ON DELETE CASCADE
);

-- Comments on posts
CREATE TABLE komentar (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_objave INT NOT NULL,
    id_uporabnika INT NOT NULL,
    besedilo TEXT NOT NULL,
    datum DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_objave) REFERENCES objava(id) ON DELETE CASCADE,
    FOREIGN KEY (id_uporabnika) REFERENCES uporabnik(id) ON DELETE CASCADE
);


-- =====================================================
-- SAMPLE DATA
-- =====================================================

INSERT INTO modul (id, naslov, opis, vrstni_red) VALUES
(1, 'Interface Basics', 'Find your way around Blender: editors, navigation, selecting and moving objects.', 1),
(2, 'Modeling', 'Build 3D shapes in Edit Mode with extrude, inset, loop cuts, bevels and modifiers.', 2),
(3, 'Texturing', 'Unwrap UVs, paint your own textures and use image textures from photos.', 3),
(4, 'Shading & Rendering', 'Materials, lights, the camera and your first finished render.', 4),
(5, 'Sculpting', 'Shape organic forms with sculpt brushes, like working with digital clay.', 5),
(6, 'Guided Projects', 'Four beginner models built click by click: a mug, a house, a snowman and a cute cottage.', 6);

INSERT INTO lekcija (id_modula, naslov, vsebina, slika_gif, vrstni_red) VALUES
(1, 'The Blender Interface', '<p>When you open Blender and click away the splash screen you see the <b>default scene</b>: a cube, a camera and a light. Blender looks crowded at first, but the screen is just a few <b>editors</b> placed side by side.</p>
<h3>The four editors you use all the time</h3>
<table class="tabela">
<tr><th>Editor</th><th>Where</th><th>What it is for</th></tr>
<tr><td><b>3D Viewport</b></td><td>big area in the middle</td><td>See and edit your scene. Almost all modeling happens here.</td></tr>
<tr><td><b>Outliner</b></td><td>top right</td><td>A list of every object. Click a name to select it, click the eye icon to hide it, double-click to rename.</td></tr>
<tr><td><b>Properties</b></td><td>bottom right</td><td>Settings for the selected object. The vertical tabs on its left side switch between Render, Output, World, Object, <b>Modifiers</b> (wrench), <b>Material</b> (red sphere) and more.</td></tr>
<tr><td><b>Timeline</b></td><td>bottom</td><td>Frames and keyframes for animation. You can ignore it while modeling.</td></tr>
</table>
<h3>Workspaces</h3>
<p>The tabs at the very top (<b>Layout, Modeling, Sculpting, UV Editing, Texture Paint, Shading, ...</b>) are <b>workspaces</b>. Each one is the same scene with editors arranged for one job. Switching tabs never changes your model, only the layout around it.</p>
<h3>Changing the layout</h3>
<ul>
<li>Drag the border between two editors to resize them.</li>
<li>Every editor has an <b>Editor Type</b> button in its top-left corner. Click it to turn that area into any other editor.</li>
<li><kbd>Ctrl</kbd>+<kbd>Space</kbd> with the mouse over an editor maximizes it. Press it again to go back.</li>
</ul>
<h3>Panels inside the 3D Viewport</h3>
<ul>
<li><kbd>T</kbd> toggles the <b>Toolbar</b> on the left (select, move, rotate, scale, ... tools).</li>
<li><kbd>N</kbd> toggles the <b>Sidebar</b> on the right. Its <b>Item</b> tab shows exact Location, Rotation, Scale and Dimensions, and you can type numbers there.</li>
<li>After almost every action a small <b>Adjust Last Operation</b> panel appears in the bottom-left corner. Open it to change the settings of what you just did, for example the number of vertices of a new cylinder. If you click somewhere else it disappears, so use it right away.</li>
</ul>
<h3>Three keys that save beginners</h3>
<ul>
<li><kbd>F3</kbd> opens <b>search</b>. Type the name of any command (for example "bevel") and press Enter.</li>
<li><kbd>Ctrl</kbd>+<kbd>Z</kbd> undoes, <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Z</kbd> redoes.</li>
<li><kbd>Ctrl</kbd>+<kbd>S</kbd> saves your .blend file. Blender also keeps automatic backups (File &rarr; Recover).</li>
</ul>
<div class="nasvet">Keyboard shortcuts work on the editor your <b>mouse is over</b>. If a shortcut "does nothing", move the mouse over the 3D Viewport and try again.</div>
<h3>Try it</h3>
<ol><li>Click the camera in the Outliner and look at how the Properties tabs change.</li><li>Switch to the <b>Shading</b> workspace and back to <b>Layout</b>.</li><li>Press <kbd>N</kbd>, select the cube and change its Location Z to 2 in the Item tab.</li></ol>', 'img/lekcije/zacetna_scena.jpg', 1),

(1, 'Navigating the 3D Viewport', '<p>Before you can build anything you need to look at it from every side. Navigation never changes your scene; it only moves your <b>view</b>.</p>
<table class="tabela">
<tr><th>Action</th><th>Mouse / keyboard</th></tr>
<tr><td>Orbit (rotate the view)</td><td>hold <kbd>Middle mouse</kbd> and drag</td></tr>
<tr><td>Pan (slide the view)</td><td><kbd>Shift</kbd> + <kbd>Middle mouse</kbd> drag</td></tr>
<tr><td>Zoom</td><td>scroll the wheel, or <kbd>Ctrl</kbd> + <kbd>Middle mouse</kbd> drag</td></tr>
<tr><td>Front / Right / Top view</td><td><kbd>Numpad 1</kbd> / <kbd>Numpad 3</kbd> / <kbd>Numpad 7</kbd></td></tr>
<tr><td>Back / Left / Bottom view</td><td><kbd>Ctrl</kbd> + the same numpad key</td></tr>
<tr><td>Perspective / Orthographic</td><td><kbd>Numpad 5</kbd></td></tr>
<tr><td>Zoom to the selected object</td><td><kbd>Numpad .</kbd> (View &rarr; Frame Selected)</td></tr>
<tr><td>Show everything</td><td><kbd>Home</kbd></td></tr>
<tr><td>Look through the camera</td><td><kbd>Numpad 0</kbd></td></tr>
</table>
<h3>No numpad or no mouse wheel?</h3>
<ul>
<li>Press <kbd>~</kbd> (the key left of 1) for a pie menu with all views.</li>
<li>Use the <b>navigation gizmo</b> in the top-right corner of the viewport: click X, Y or Z to snap to that view, drag the ball to orbit, drag the hand icon to pan and the magnifier to zoom.</li>
<li>On a laptop go to <b>Edit &rarr; Preferences &rarr; Input</b> and turn on <b>Emulate 3 Button Mouse</b> (then <kbd>Alt</kbd> + left drag orbits) and <b>Emulate Numpad</b> (then the normal 1, 3, 7 keys switch views).</li>
</ul>
<h3>Viewport shading</h3>
<p>Press <kbd>Z</kbd> for the shading pie menu, or use the four sphere buttons in the top-right corner:</p>
<ul>
<li><b>Wireframe</b> shows only edges. Good for seeing through objects.</li>
<li><b>Solid</b> is the default gray clay look. Fast and best for modeling.</li>
<li><b>Material Preview</b> shows your materials and textures with a test light.</li>
<li><b>Rendered</b> shows what the final render will look like with your own lights.</li>
</ul>
<div class="nasvet">Orthographic front/side views (<kbd>Numpad 1</kbd> then <kbd>Numpad 3</kbd>) are perfect for lining things up, because nothing gets smaller with distance.</div>
<h3>Try it</h3>
<p>Orbit around the cube, then press <kbd>Numpad 1</kbd>, <kbd>Numpad 3</kbd> and <kbd>Numpad 7</kbd>. Notice the label in the top-left corner of the viewport changes to "Front Orthographic", "Right Orthographic" and "Top Orthographic".</p>', 'img/lekcije/gif_premikanje.gif', 2),

(1, 'Selecting, Adding and Transforming Objects', '<h3>Selecting</h3>
<ul>
<li><b>Left click</b> selects one object. The lighter orange outline is the <b>active</b> object.</li>
<li><kbd>Shift</kbd> + click adds to the selection (or removes an already selected object).</li>
<li><kbd>A</kbd> selects all, <kbd>Alt</kbd>+<kbd>A</kbd> deselects all, <kbd>Ctrl</kbd>+<kbd>I</kbd> inverts.</li>
<li><kbd>B</kbd> box select (drag a rectangle), <kbd>C</kbd> circle select (paint over objects, right click to finish).</li>
</ul>
<h3>Adding, duplicating and deleting</h3>
<ul>
<li><kbd>Shift</kbd>+<kbd>A</kbd> opens the Add menu (Mesh &rarr; Cube, UV Sphere, Cylinder, ...). New objects appear at the <b>3D cursor</b> (the red-white circle).</li>
<li><kbd>Shift</kbd> + <b>right click</b> moves the 3D cursor. <kbd>Shift</kbd>+<kbd>S</kbd> &rarr; <b>Cursor to World Origin</b> puts it back in the center.</li>
<li><kbd>Shift</kbd>+<kbd>D</kbd> duplicates and starts moving the copy. Right click to leave the copy in the same place.</li>
<li><kbd>X</kbd> or <kbd>Delete</kbd> deletes the selection.</li>
</ul>
<h3>Move, rotate, scale</h3>
<p>Press a key, move the mouse, then <b>left click</b> (or <kbd>Enter</kbd>) to confirm. <b>Right click</b> (or <kbd>Esc</kbd>) cancels.</p>
<table class="tabela">
<tr><th>Key</th><th>Does</th><th>Example</th></tr>
<tr><td><kbd>G</kbd></td><td>Move (grab)</td><td><kbd>G</kbd> <kbd>Z</kbd> <kbd>2</kbd> <kbd>Enter</kbd> moves 2 m up</td></tr>
<tr><td><kbd>R</kbd></td><td>Rotate</td><td><kbd>R</kbd> <kbd>X</kbd> <kbd>9</kbd><kbd>0</kbd> <kbd>Enter</kbd> rotates 90&deg; around X</td></tr>
<tr><td><kbd>S</kbd></td><td>Scale</td><td><kbd>S</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>5</kbd> <kbd>Enter</kbd> makes it half the size</td></tr>
</table>
<ul>
<li>After G, R or S press <kbd>X</kbd>, <kbd>Y</kbd> or <kbd>Z</kbd> to lock to that axis. Press <kbd>Shift</kbd>+<kbd>Z</kbd> to lock to everything <i>except</i> Z (for example, scale only width and depth).</li>
<li>Hold <kbd>Ctrl</kbd> while moving to snap in steps, hold <kbd>Shift</kbd> for slow, precise movement.</li>
<li><kbd>Alt</kbd>+<kbd>G</kbd>, <kbd>Alt</kbd>+<kbd>R</kbd>, <kbd>Alt</kbd>+<kbd>S</kbd> reset location, rotation or scale.</li>
</ul>
<h3>Apply the scale (important!)</h3>
<p>If you scale an object in Object Mode, Blender remembers the scale (for example 3, 1, 1). Tools such as Bevel, Inset and many modifiers then look stretched. Fix it with <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>. The object looks the same, but its scale is reset to 1.</p>
<div class="nasvet">Typing numbers is the secret to clean models. Instead of guessing with the mouse, type the exact value after G, R or S.</div>
<h3>Try it</h3>
<ol><li>Add a UV Sphere and move it up with <kbd>G</kbd> <kbd>Z</kbd> <kbd>2</kbd>.</li><li>Duplicate it with <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>X</kbd> <kbd>3</kbd> <kbd>Enter</kbd>.</li><li>Make the copy flat: <kbd>S</kbd> <kbd>Z</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>3</kbd>, then apply the scale with <kbd>Ctrl</kbd>+<kbd>A</kbd>.</li></ol>', 'img/lekcije/gif_transformacije.gif', 3),

(2, 'Edit Mode: Vertices, Edges and Faces', '<p>A mesh is made of <b>vertices</b> (points), <b>edges</b> (lines between points) and <b>faces</b> (surfaces between edges). In Object Mode you move whole objects; in <b>Edit Mode</b> you change their shape.</p>
<ul>
<li><kbd>Tab</kbd> switches between Object Mode and Edit Mode for the selected object.</li>
<li><kbd>1</kbd> vertex select, <kbd>2</kbd> edge select, <kbd>3</kbd> face select (top row keys, not numpad). The same buttons are in the viewport header.</li>
<li><kbd>G</kbd>, <kbd>R</kbd>, <kbd>S</kbd>, axis locking and typed numbers work exactly like in Object Mode.</li>
</ul>
<h3>Smart selection</h3>
<table class="tabela">
<tr><th>Shortcut</th><th>Selects</th></tr>
<tr><td><kbd>Alt</kbd> + click an edge</td><td>the whole <b>edge loop</b> (a ring of edges around the model)</td></tr>
<tr><td><kbd>Ctrl</kbd> + click</td><td>the shortest path between the last selected element and the click</td></tr>
<tr><td><kbd>L</kbd> with the mouse over a part</td><td>everything connected to it</td></tr>
<tr><td><kbd>Ctrl</kbd> + <kbd>Numpad +</kbd> / <kbd>-</kbd></td><td>grow / shrink the selection</td></tr>
<tr><td><kbd>Alt</kbd>+<kbd>Z</kbd></td><td>X-ray, so box select also grabs the hidden back side</td></tr>
</table>
<h3>Deleting the right way</h3>
<p><kbd>X</kbd> opens a menu. <b>Vertices / Edges / Faces</b> remove geometry and leave a hole. <b>Dissolve</b> removes edges or vertices but keeps the surface closed. Use dissolve when you want to clean up, delete when you want a hole.</p>
<h3>Joining and filling</h3>
<ul>
<li><kbd>M</kbd> merges selected vertices (At Center, At Last, <b>By Distance</b> to remove doubled vertices).</li>
<li><kbd>F</kbd> fills: two vertices become an edge, a closed ring of edges becomes a face.</li>
</ul>
<h3>Proportional editing</h3>
<p>Press <kbd>O</kbd> to toggle it. Now moving one vertex also pulls its neighbors softly. Scroll the mouse wheel while moving to change the circle of influence. Great for hills, cloth and bumps.</p>
<div class="nasvet">The statistics overlay shows how many vertices and faces are selected. Turn it on in the <b>Overlays</b> dropdown &rarr; Statistics.</div>
<h3>Try it</h3>
<p>On the default cube: <kbd>Tab</kbd>, <kbd>3</kbd>, click the top face, <kbd>G</kbd> <kbd>Z</kbd> <kbd>1</kbd> <kbd>Enter</kbd>. The cube becomes a tall box. Now press <kbd>2</kbd>, <kbd>Alt</kbd>+click a vertical edge and scale it with <kbd>S</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>5</kbd>.</p>', 'img/lekcije/edit_mode.jpg', 1),

(2, 'Extrude, Inset, Loop Cut and Bevel', '<p>These four tools build almost every beginner model. All of them work in <b>Edit Mode</b>.</p>
<h3>Extrude <kbd>E</kbd></h3>
<p>Pulls new geometry out of the selection. Select a face, press <kbd>E</kbd> and move the mouse; the new face moves along its normal (straight out). Type a number to set the distance: <kbd>E</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>5</kbd> <kbd>Enter</kbd>. A negative number pushes inward (<kbd>E</kbd> <kbd>-</kbd><kbd>0</kbd><kbd>.</kbd><kbd>2</kbd>), which is how you make a dent. With several faces selected, <kbd>Alt</kbd>+<kbd>E</kbd> &rarr; <b>Extrude Faces Along Normals</b> pushes each one straight out.</p>
<div class="nasvet">If you press E and then cancel with a right click, the new geometry still exists, sitting on top of the old one. Press <kbd>Ctrl</kbd>+<kbd>Z</kbd> to really undo it.</div>
<h3>Inset <kbd>I</kbd></h3>
<p>Makes a smaller copy of a face inside it, with a border around it. Move the mouse toward the face center or type a thickness (<kbd>I</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>1</kbd>). Press <kbd>I</kbd> twice to inset each selected face separately. Inset + extrude inward = windows, doors, screens and holes.</p>
<h3>Loop Cut <kbd>Ctrl</kbd>+<kbd>R</kbd></h3>
<ol>
<li>Hover over an edge. A yellow preview line appears across it.</li>
<li><b>Scroll</b> the wheel to add more cuts.</li>
<li><b>Left click</b> to place the cut. Now you can slide it.</li>
<li><b>Right click</b> to keep it exactly in the middle, or left click to confirm the slid position.</li>
</ol>
<p>Loop cuts add rows of faces where you need detail, and they keep edges sharp when you use subdivision (next lesson).</p>
<h3>Bevel <kbd>Ctrl</kbd>+<kbd>B</kbd></h3>
<p>Rounds or cuts off selected edges. Move the mouse for the width and <b>scroll</b> for more segments (2 or 3 segments look round). Real objects never have perfectly sharp edges, so a small bevel makes models look much more real. <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>B</kbd> bevels vertices instead.</p>
<h3>Bonus tools</h3>
<ul>
<li><kbd>K</kbd> <b>Knife</b>: click to draw new edges across faces, <kbd>Enter</kbd> to confirm.</li>
<li><b>Bridge Edge Loops</b> (Edge menu): connects two selected edge loops with faces, for example to join two tubes.</li>
</ul>
<h3>Try it: a picture frame</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; Plane, then <kbd>Tab</kbd> and <kbd>3</kbd>.</li><li><kbd>I</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>2</kbd> <kbd>Enter</kbd>. The inner face will be the picture.</li><li><kbd>Ctrl</kbd>+<kbd>I</kbd> inverts the selection so the frame border is selected. <kbd>E</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>1</kbd> <kbd>Enter</kbd> raises the frame.</li><li>Press <kbd>2</kbd>, <kbd>Alt</kbd>+click the outer top edge of the frame, <kbd>Ctrl</kbd>+<kbd>B</kbd>, scroll to 2 segments and click to round it.</li></ol>', 'img/lekcije/gif_extrude.gif', 2),

(2, 'Modifiers: Subdivision, Mirror, Bevel, Solidify, Array', '<p>A <b>modifier</b> changes how an object looks without destroying its original mesh. You can change or remove it at any time. Find them in the <b>Properties &rarr; Modifiers</b> tab (blue wrench) &rarr; <b>Add Modifier</b>.</p>
<h3>Subdivision Surface</h3>
<p>Splits every face into smaller faces and smooths the result, so a blocky cage becomes a smooth model. Shortcut in Object Mode: <kbd>Ctrl</kbd>+<kbd>1</kbd>, <kbd>2</kbd> or <kbd>3</kbd> (the level). Also right click &rarr; <b>Shade Smooth</b> so the faces look smooth instead of faceted.</p>
<p><b>Problem:</b> a subdivided cube turns into a ball. <b>Fix:</b> add <b>support loops</b> with <kbd>Ctrl</kbd>+<kbd>R</kbd> close to the edges that should stay sharp. The closer the loops, the sharper the edge.</p>
<h3>Mirror</h3>
<p>Model one half, get the other half for free. In Edit Mode delete one half of the model (for example everything with negative X), add a <b>Mirror</b> modifier and turn on <b>Clipping</b> so vertices in the middle cannot cross the center. Perfect for faces, characters, cars and furniture.</p>
<h3>Bevel</h3>
<p>Bevels every edge automatically. Set <b>Amount</b> (width) and <b>Segments</b>. Under <b>Limit Method &rarr; Angle</b> only sharp edges are beveled. Apply the object scale first (<kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale), otherwise the bevel is uneven.</p>
<h3>Solidify</h3>
<p>Gives a flat surface thickness. Make a plane, add Solidify, and you have a wall, a sheet of paper or a leaf with a real thickness.</p>
<h3>Array</h3>
<p>Repeats the object. <b>Count</b> sets how many copies, <b>Relative Offset</b> sets the gap (1 = touching). Great for fences, stairs and chains.</p>
<h3>The stack order matters</h3>
<p>Modifiers run from top to bottom. Mirror above Subdivision gives a smooth seam in the middle; the opposite order can leave a crease. Drag the handle (six dots) on a modifier to reorder. When you are happy, use the dropdown arrow &rarr; <b>Apply</b> (or <kbd>Ctrl</kbd>+<kbd>A</kbd> with the mouse over the modifier) to make it real geometry.</p>
<div class="nasvet">Keep modifiers live as long as possible. Applying is permanent, and you lose the ability to change the settings.</div>
<h3>Try it</h3>
<p>Add a cube, press <kbd>Ctrl</kbd>+<kbd>2</kbd> and Shade Smooth. Then in Edit Mode add a loop cut near the top edge and watch the top become flatter as you slide the loop closer to the edge.</p>', 'img/lekcije/gif_subdivision.gif', 3),

(3, 'UV Unwrapping', '<p>A texture is a flat 2D image. To wrap it around a 3D model, Blender needs a <b>UV map</b>: the model cut open and laid flat, like a cardboard box that you cut and unfold. U and V are just the names of the two axes of the image.</p>
<h3>Step 1: mark seams</h3>
<p>Seams are the edges where the model will be cut. For a cylinder (like a mug or a can) that is the ring around the top, the ring around the bottom and one vertical edge.</p>
<ol>
<li>Go to the <b>UV Editing</b> workspace. Left is the UV Editor, right is the 3D Viewport in Edit Mode.</li>
<li>Press <kbd>2</kbd> for edge select. <kbd>Alt</kbd>+click the top ring, <kbd>Shift</kbd>+<kbd>Alt</kbd>+click the bottom ring, <kbd>Shift</kbd>+click one vertical edge.</li>
<li>Press <kbd>Ctrl</kbd>+<kbd>E</kbd> (Edge menu) &rarr; <b>Mark Seam</b>. The edges turn red.</li>
</ol>
<h3>Step 2: unwrap</h3>
<p>Select everything with <kbd>A</kbd>, press <kbd>U</kbd> &rarr; <b>Unwrap</b>. The UV Editor now shows flat pieces called <b>islands</b>: two circles (top and bottom) and a long rectangle (the side).</p>
<h3>Other unwrap options in the <kbd>U</kbd> menu</h3>
<ul>
<li><b>Smart UV Project</b>: cuts automatically by angle. Fast and good for hard-surface objects like boxes, furniture and buildings. No seams needed.</li>
<li><b>Cube / Cylinder / Sphere Projection</b>: project from a simple shape.</li>
<li><b>Project From View</b>: projects exactly what you see from the current view, useful for flat things like a poster.</li>
</ul>
<h3>Step 3: check for stretching</h3>
<ol>
<li>In the UV Editor open the <b>Overlays</b> dropdown and enable <b>Display Stretch</b>. Blue means fine, green to red means more and more stretched.</li>
<li>For a visual test, in the UV Editor click <b>Image &rarr; New</b>, set <b>Generated Type</b> to <b>UV Grid</b> and connect that image to your material''s Base Color (see "Image Textures"). Squares should look square on the model.</li>
<li>If squares on the grid look stretched, add or move seams and unwrap again.</li>
</ol>
<h3>Arrange the islands</h3>
<p>In the UV Editor you can move, rotate and scale islands with <kbd>G</kbd>, <kbd>R</kbd>, <kbd>S</kbd>. <b>UV &rarr; Average Islands Scale</b> makes all islands the same texel density, and <b>UV &rarr; Pack Islands</b> fits them neatly into the square without overlapping.</p>
<div class="nasvet">Hide seams where nobody looks: under the object, behind it, or along natural edges like where a sleeve meets a shirt.</div>
<h3>Try it</h3>
<p>Add a cylinder, mark the three seams described above, unwrap and use Pack Islands. You will reuse this exact UV map when you paint the mug in the next lesson.</p>', 'img/lekcije/teksturiranje.jpg', 1),

(3, 'Texture Painting: How to Actually Paint', '<p>In Texture Paint mode you paint colors straight onto the 3D model, like painting a real figure with a brush. The paint is stored in an <b>image</b> that is wrapped around the model with the UV map from the previous lesson.</p>
<h3>1. Prepare the model</h3>
<ol>
<li>Make sure the model has a UV map (Edit Mode, <kbd>A</kbd>, <kbd>U</kbd> &rarr; Unwrap or Smart UV Project). Overlapping UV islands would paint in two places at once.</li>
<li>Give the object a material: Properties &rarr; <b>Material</b> tab &rarr; <b>New</b>.</li>
<li>Apply the scale (<kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale), otherwise the brush looks squished.</li>
</ol>
<h3>2. Create an image to paint on</h3>
<ol>
<li>Switch to the <b>Texture Paint</b> workspace. If the model is <b>pink/purple</b>, it means "no texture to paint on yet". That is normal.</li>
<li>In the Properties editor open the <b>Active Tool</b> tab (screwdriver and wrench icon) and find the <b>Texture Slots</b> panel. Keep <b>Mode: Material</b>.</li>
<li>Click <b>+</b> and choose <b>Base Color</b>. Name it (for example <code>mug_color</code>), set <b>Width</b> and <b>Height</b> to <b>2048</b>, pick a starting <b>Color</b> (white or the main color of your object) and click <b>OK</b>.</li>
<li>Blender creates the image and connects it to the Base Color of your material automatically. The model now shows the starting color.</li>
</ol>
<h3>3. Know your brush settings</h3>
<p>All important settings are in the viewport header at the top (and in the Active Tool tab):</p>
<table class="tabela">
<tr><th>Setting</th><th>How</th><th>What it does</th></tr>
<tr><td><b>Color</b></td><td>click the color swatch</td><td>The color you paint with. Use the wheel or type a Hex code like <code>FF8A1F</code>.</td></tr>
<tr><td><b>Radius</b></td><td><kbd>F</kbd>, move mouse, click</td><td>Brush size in pixels on screen. Zooming in makes the brush relatively smaller for fine details.</td></tr>
<tr><td><b>Strength</b></td><td><kbd>Shift</kbd>+<kbd>F</kbd></td><td>How much paint each stroke puts down. 1.0 is full color, 0.2 is a light glaze you can build up.</td></tr>
<tr><td><b>Blend</b></td><td>dropdown</td><td><b>Mix</b> paints normally, <b>Multiply</b> darkens (shadows, dirt), <b>Add/Lighten</b> brightens, <b>Erase Alpha</b> erases to transparent.</td></tr>
<tr><td><b>Falloff</b></td><td>Falloff panel</td><td>Soft edge or hard edge. Choose the <b>Constant</b> preset for crisp shapes, <b>Smooth</b> for soft gradients.</td></tr>
<tr><td><b>Sample color</b></td><td><kbd>S</kbd> over the model</td><td>Picks a color from the model, like an eyedropper.</td></tr>
<tr><td><b>Swap colors</b></td><td><kbd>X</kbd></td><td>Swaps the primary and secondary color, handy for going back and forth between two colors.</td></tr>
</table>
<h3>4. The paint tools (brushes)</h3>
<p>In Blender 4.3 and newer, brushes are chosen from the <b>brush picker</b> in the header (asset shelf). In older versions they are tools in the left toolbar. The names are the same:</p>
<ul>
<li><b>Paint / Draw</b>: the normal brush. Use it for almost everything.</li>
<li><b>Soften</b>: blurs what you painted, to blend two colors.</li>
<li><b>Smear</b>: drags colors like wet paint.</li>
<li><b>Clone</b>: copies one part of the image to another (<kbd>Ctrl</kbd>+click sets the source).</li>
<li><b>Fill</b>: fills an area with one color in a single click. Turn the <b>Fill Threshold</b> up to fill bigger areas. In <b>Gradient</b> mode you drag to make a gradient.</li>
<li><b>Mask</b>: paints a protective mask so other brushes cannot paint there.</li>
</ul>
<h3>5. Paint with control</h3>
<ul>
<li><b>Stroke Method</b> (Stroke panel): <b>Space</b> is the normal smooth stroke, <b>Line</b> lets you drag a perfectly straight line, <b>Airbrush</b> keeps adding paint while you hold still.</li>
<li><b>Symmetry</b>: the butterfly icon in the header with <b>X</b> enabled paints both sides at once, perfect for faces.</li>
<li><b>Paint Mask (face selection)</b>: in Edit Mode select only the faces you want, go back to Texture Paint and enable the <b>Paint Mask</b> button (cube with a face) in the header. Now paint goes <i>only</i> on those faces. This is the easiest way to paint clean stripes or a label.</li>
<li><b>Bleed</b> (Options panel): how many pixels the paint spills past UV island borders. Raise it to 8&ndash;16 px if you see thin seams in the paint.</li>
<li>With a <b>graphics tablet</b>, click the pressure icons next to Radius and Strength so pressing harder paints bigger or stronger.</li>
</ul>
<h3>6. A good painting workflow</h3>
<ol>
<li>Start with a <b>base color</b> (the color you chose in step 2).</li>
<li>Block in big color areas with a hard brush (Constant falloff, strength 1).</li>
<li>Add soft shading: <b>Multiply</b> blend, dark color, strength 0.1&ndash;0.2, soft falloff, in corners and under parts.</li>
<li>Add highlights: <b>Lighten</b> blend on edges that stick out.</li>
<li>Add small details last (zoom in, small radius).</li>
</ol>
<h3>7. SAVE THE IMAGE</h3>
<p>The painted image is <b>not</b> saved when you press <kbd>Ctrl</kbd>+<kbd>S</kbd> for the .blend file! In the Image Editor on the left use <b>Image &rarr; Save As</b> (<kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd>) and save a PNG next to your .blend file. After that, <b>Image &rarr; Save</b> (<kbd>Alt</kbd>+<kbd>S</kbd>) updates it. An asterisk (<b>*</b>) next to the Image menu means there are unsaved changes. Alternative: <b>File &rarr; External Data &rarr; Pack Resources</b> stores the image inside the .blend file.</p>
<div class="nasvet">You can also paint in 2D: in the Image Editor switch the mode in the header from View to <b>Paint</b>. Painting on the flat UV layout is great for straight lines and text.</div>
<h3>Try it: paint the mug</h3>
<ol><li>Unwrap your mug (or a cylinder), add a 2048 Base Color texture in light blue.</li><li>Select the middle ring of faces in Edit Mode, enable Paint Mask and paint a white stripe with a hard brush.</li><li>Turn Paint Mask off, use Multiply with a dark blue at strength 0.15 to shade the bottom.</li><li>Save the image with <b>Image &rarr; Save As</b>.</li></ol>', 'img/lekcije/barvanje.jpg', 2),

(3, 'Image Textures from Photos', '<p>Instead of painting everything yourself, you can use photo textures like wood, bricks or fabric. Free, safe sources are <b>Poly Haven</b> and <b>ambientCG</b> (both CC0, free to use for anything).</p>
<h3>What is in a texture set?</h3>
<table class="tabela">
<tr><th>Map</th><th>Connect to</th><th>Color Space</th></tr>
<tr><td>Color / Albedo / Diffuse</td><td>Base Color</td><td>sRGB</td></tr>
<tr><td>Roughness</td><td>Roughness</td><td><b>Non-Color</b></td></tr>
<tr><td>Normal (often "_nor_gl")</td><td>Normal Map node &rarr; Normal</td><td><b>Non-Color</b></td></tr>
<tr><td>Displacement / Height</td><td>Displacement node (optional)</td><td><b>Non-Color</b></td></tr>
</table>
<h3>Connect a texture by hand</h3>
<ol>
<li>Open the <b>Shading</b> workspace. The bottom half is the <b>Shader Editor</b> with your material''s nodes.</li>
<li>Drag the image file from your computer into the Shader Editor, or press <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Texture &rarr; <b>Image Texture</b> and click <b>Open</b>.</li>
<li>Drag from the yellow <b>Color</b> output dot to the <b>Base Color</b> input of the Principled BSDF.</li>
<li>For roughness and normal maps change <b>Color Space</b> on the image node to <b>Non-Color</b>, otherwise the material looks wrong.</li>
</ol>
<h3>The fast way: Node Wrangler</h3>
<p>Enable it once: <b>Edit &rarr; Preferences &rarr; Add-ons</b>, search "Node Wrangler", tick the box. Then:</p>
<ul>
<li>Select the Principled BSDF and press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd>. Select all maps of a texture set at once and click <b>Principled Texture Setup</b>. Every map is connected correctly with the right color space.</li>
<li>Select an image node and press <kbd>Ctrl</kbd>+<kbd>T</kbd> to add <b>Texture Coordinate</b> and <b>Mapping</b> nodes.</li>
</ul>
<h3>Make the texture the right size</h3>
<p>In the <b>Mapping</b> node increase <b>Scale</b> (for example 4, 4, 4) to make the pattern repeat more often, so bricks are not giant. Rotation Z turns the pattern. If the texture looks stretched, the UVs are stretched: go back to the UV Unwrapping lesson.</p>
<div class="nasvet">Seamless (tileable) textures repeat without visible edges. Most textures from Poly Haven and ambientCG are seamless.</div>
<h3>Try it</h3>
<p>Download a wood texture, unwrap a cube with Smart UV Project and use Node Wrangler to set it up. Change the Mapping scale until the wood grain looks realistic.</p>', 'img/lekcije/teksturiranje.jpg', 3),

(4, 'Materials and the Principled BSDF', '<p>A material decides how light reacts with a surface: color, shine, metal, glass or glow. Blender''s main shader is the <b>Principled BSDF</b>, which can make almost every real material.</p>
<h3>Create a material</h3>
<ol>
<li>Select an object, open the <b>Material</b> tab (red sphere) in Properties and click <b>New</b>.</li>
<li>Double-click the name and give it a real name (for example <code>Ceramic Blue</code>).</li>
<li>Press <kbd>Z</kbd> &rarr; <b>Material Preview</b> to see it.</li>
</ol>
<h3>The settings that matter</h3>
<table class="tabela">
<tr><th>Setting</th><th>Values</th><th>Use it for</th></tr>
<tr><td><b>Base Color</b></td><td>any color</td><td>The main color.</td></tr>
<tr><td><b>Metallic</b></td><td>0 or 1</td><td>1 for metals (gold, steel), 0 for everything else. Values in between are rarely realistic.</td></tr>
<tr><td><b>Roughness</b></td><td>0 to 1</td><td>0 = mirror-like and glossy, 0.5 = satin, 1 = matte (chalk, fabric).</td></tr>
<tr><td><b>IOR</b></td><td>1.45 default</td><td>How strongly light bends; 1.33 water, 1.5 glass.</td></tr>
<tr><td><b>Alpha</b></td><td>0 to 1</td><td>Transparency for cut-outs like leaves.</td></tr>
<tr><td><b>Transmission Weight</b></td><td>0 or 1</td><td>1 with Roughness 0 makes clear <b>glass</b>.</td></tr>
<tr><td><b>Emission Color / Strength</b></td><td>color, 1&ndash;20</td><td>Glowing screens, lamps, lava.</td></tr>
<tr><td><b>Subsurface Weight</b></td><td>0 to 1</td><td>Light that shines through skin, wax, soap.</td></tr>
</table>
<h3>Recipes</h3>
<ul>
<li><b>Plastic</b>: any color, Metallic 0, Roughness 0.3.</li>
<li><b>Ceramic</b>: Metallic 0, Roughness 0.1&ndash;0.2.</li>
<li><b>Gold</b>: Base Color yellow-orange, Metallic 1, Roughness 0.2.</li>
<li><b>Rubber</b>: dark color, Roughness 0.8.</li>
<li><b>Glass</b>: Transmission 1, Roughness 0, white color.</li>
</ul>
<h3>Several materials on one object</h3>
<ol>
<li>In the Material tab click <b>+</b> next to the list to add a second <b>material slot</b>, then <b>New</b>.</li>
<li>In Edit Mode select the faces that should get it (for example the roof of a house).</li>
<li>With that slot selected in the list, click <b>Assign</b>.</li>
</ol>
<p>To reuse an existing material on another object, click the sphere dropdown next to New and pick it from the list.</p>
<div class="nasvet">The <b>Shading</b> workspace shows the same material as nodes in the Shader Editor. Every value in the Material tab is the same value on the Principled BSDF node.</div>
<h3>Try it</h3>
<p>Make three spheres side by side and give them gold, glass and red plastic materials. Compare them in Material Preview.</p>', 'img/lekcije/gif_materiali.gif', 1),

(4, 'Lighting a Scene', '<p>Lighting makes the difference between a flat and a beautiful render. Add lights with <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; <b>Light</b>. Their settings are in the green light-bulb tab in Properties.</p>
<h3>The four light types</h3>
<table class="tabela">
<tr><th>Type</th><th>Behaves like</th><th>Typical power</th></tr>
<tr><td><b>Point</b></td><td>a bare light bulb, shines in all directions</td><td>100&ndash;1000 W</td></tr>
<tr><td><b>Sun</b></td><td>sunlight: same direction everywhere, position does not matter, only rotation</td><td>Strength 2&ndash;5</td></tr>
<tr><td><b>Spot</b></td><td>a flashlight or stage spotlight (cone)</td><td>500&ndash;2000 W</td></tr>
<tr><td><b>Area</b></td><td>a softbox or window, gives soft studio light</td><td>200&ndash;1000 W</td></tr>
</table>
<p><b>Shadows:</b> a bigger <b>Radius</b> (Point, Spot), <b>Size</b> (Area) or <b>Angle</b> (Sun) makes softer shadows. Small values make sharp shadows.</p>
<h3>Three-point lighting (studio classic)</h3>
<ol>
<li><b>Key light</b>: the brightest Area light, 45&deg; to the side and above the object.</li>
<li><b>Fill light</b>: on the other side, about one third of the power, so shadows are not completely black.</li>
<li><b>Rim light</b>: behind the object, pointing at the camera; it draws a bright outline that separates the object from the background.</li>
</ol>
<p>To aim a light quickly: select it, press <kbd>R</kbd> twice for free rotation, or add an <b>Object Constraint &rarr; Track To</b> with your object as target.</p>
<h3>World light</h3>
<p>The <b>World</b> tab (red globe) controls the background and the light coming from the sky. Set <b>Color</b> for a simple sky. For realistic light, click the yellow dot next to Color, choose <b>Environment Texture</b> and open an <b>HDRI</b> image (free on Poly Haven). The HDRI lights your scene like a real place.</p>
<h3>Light color</h3>
<p>Warm (orange) key light + cool (blue) fill light looks natural and cinematic. Keep colors subtle.</p>
<div class="nasvet">Use the <b>Rendered</b> viewport shading (<kbd>Z</kbd> &rarr; Rendered) while you place lights, so you see the result live.</div>
<h3>Try it</h3>
<p>Delete the default light, add a Sun with Strength 3 and rotate it so shadows fall diagonally. Then add an Area light as a rim light behind your object.</p>', 'img/lekcije/luci.jpg', 2),

(4, 'Camera and Rendering', '<h3>Set up the camera</h3>
<ul>
<li><kbd>Numpad 0</kbd> looks through the active camera.</li>
<li>The easiest way to place it: navigate the viewport to a nice view, then press <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd>. The camera jumps to your view.</li>
<li>For fine-tuning open the Sidebar (<kbd>N</kbd>) &rarr; <b>View</b> tab &rarr; enable <b>Lock Camera to View</b>. Now orbiting and panning moves the camera itself. Turn it off when you are done.</li>
<li>In the camera settings (green camera tab) <b>Focal Length</b> 50 mm looks natural, 85 mm is good for portraits and products, 24 mm is wide for rooms and landscapes.</li>
</ul>
<h3>Choose a render engine</h3>
<p>In the <b>Render</b> tab (camera back icon):</p>
<ul>
<li><b>EEVEE</b>: real-time, renders in seconds. Great for stylized looks, animation and previews.</li>
<li><b>Cycles</b>: path tracing, slower but physically correct light, reflections and glass. Set <b>Render &rarr; Max Samples</b> to about 128 and leave <b>Denoise</b> on. If you have a graphics card, go to Edit &rarr; Preferences &rarr; System, enable it, then set <b>Device: GPU Compute</b>.</li>
</ul>
<h3>Resolution and output</h3>
<p>In the <b>Output</b> tab (printer icon) set Resolution X 1920 and Y 1080. Lower the <b>%</b> slider to 50 for quick test renders.</p>
<h3>Render and save</h3>
<ol>
<li>Press <kbd>F12</kbd>. A new window shows the image being rendered.</li>
<li>In that window choose <b>Image &rarr; Save As</b> and save as PNG. Nothing is saved automatically!</li>
<li><kbd>F11</kbd> shows the last render again if you closed the window.</li>
</ol>
<h3>Make it look better</h3>
<ul>
<li>In Render &rarr; <b>Color Management</b>, <b>View Transform AgX</b> (Filmic in older versions) handles bright lights nicely. <b>Look</b> adds contrast.</li>
<li>A floor plane under the object (and maybe a curved backdrop) gives you soft contact shadows.</li>
<li><kbd>Ctrl</kbd>+<kbd>F12</kbd> renders an animation; set the output folder in the Output tab first.</li>
</ul>
<div class="nasvet">Composition rule of thirds: in the camera view, open the Camera tab &rarr; Viewport Display &rarr; Composition Guides &rarr; Thirds, and put your object on one of the lines.</div>
<h3>Try it</h3>
<p>Set your camera with <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd>, render once in EEVEE and once in Cycles, and compare how long each took and how the shadows look.</p>', 'img/lekcije/projekt_scena.jpg', 3),

(5, 'Sculpt Mode and Brushes', '<p>Sculpting is like modeling with clay: you push, pull and smooth the surface with brushes instead of moving single vertices. It is best for organic shapes such as characters, animals, rocks and food.</p>
<h3>Get started</h3>
<ol>
<li>Add a <b>UV Sphere</b> or use the <b>Sculpting</b> workspace, which already gives you a high-resolution sphere.</li>
<li>Switch the mode to <b>Sculpt Mode</b> (mode dropdown in the top-left of the viewport).</li>
<li>Your object needs enough geometry. If strokes look blocky, see the next lesson (Remesh).</li>
</ol>
<h3>The brushes beginners need</h3>
<table class="tabela">
<tr><th>Brush</th><th>What it does</th></tr>
<tr><td><b>Draw</b></td><td>raises the surface along the stroke. Basic shapes and lines.</td></tr>
<tr><td><b>Clay Strips</b></td><td>adds flat layers of "clay". The best brush for building up forms such as cheeks and muscles.</td></tr>
<tr><td><b>Grab</b></td><td>drags a big area like soft rubber. Use it first to get the overall shape right.</td></tr>
<tr><td><b>Smooth</b></td><td>flattens bumps. Hold <kbd>Shift</kbd> with any brush to smooth temporarily.</td></tr>
<tr><td><b>Inflate</b></td><td>puffs the surface up like a balloon, great for cheeks, lips and fingers.</td></tr>
<tr><td><b>Crease</b></td><td>makes sharp grooves: eyelids, wrinkles, the line of the mouth.</td></tr>
<tr><td><b>Snake Hook</b></td><td>pulls out long shapes like horns, ears or tentacles.</td></tr>
<tr><td><b>Mask</b></td><td>paints a mask; masked areas cannot change. <kbd>Alt</kbd>+<kbd>M</kbd> clears the mask, <kbd>Ctrl</kbd>+<kbd>I</kbd> inverts it.</td></tr>
</table>
<h3>Brush controls</h3>
<ul>
<li><kbd>F</kbd> brush radius, <kbd>Shift</kbd>+<kbd>F</kbd> strength.</li>
<li>Hold <kbd>Ctrl</kbd> to invert the brush (Draw then digs in instead of raising).</li>
<li><b>Symmetry</b>: in the header the X axis is on by default for symmetric models. Turn it off for asymmetric details.</li>
<li>With a tablet enable pressure for radius and strength.</li>
</ul>
<h3>The right order</h3>
<ol>
<li><b>Big shapes first</b> with Grab and a large radius. Look from the front, side and top views.</li>
<li><b>Medium forms</b> with Clay Strips and Inflate.</li>
<li><b>Smooth</b> often (<kbd>Shift</kbd>).</li>
<li><b>Details last</b> with Crease and a small Draw brush.</li>
</ol>
<div class="nasvet">Turn on the <b>Matcap</b> view: viewport shading Solid &rarr; dropdown &rarr; Lighting: MatCap. The shiny clay look shows every bump and makes sculpting much easier.</div>
<h3>Try it</h3>
<p>Sculpt a simple stone: start from a sphere, Grab to make it uneven, Clay Strips for flat faces, Crease for cracks, Smooth to finish.</p>', 'img/lekcije/kiparjenje.jpg', 1),

(5, 'Remesh, Dyntopo and Multires', '<p>A sculpt can only show as much detail as it has polygons. These three tools control the resolution.</p>
<h3>Voxel Remesh (start here)</h3>
<p>Rebuilds the whole mesh with an even grid of polygons, as if you melted the clay and formed it again.</p>
<ul>
<li>In Sculpt Mode press <kbd>R</kbd> and move the mouse to set the <b>Voxel Size</b> (a grid preview shows the size), then <kbd>Ctrl</kbd>+<kbd>R</kbd> to remesh. You can also set Voxel Size in the <b>Remesh</b> panel in the header.</li>
<li>Smaller voxel size = more detail = slower. Start big (0.05&ndash;0.1), go smaller as you add details.</li>
<li>Remesh after big Grab or Snake Hook moves, which stretch the polygons.</li>
</ul>
<h3>Dyntopo (Dynamic Topology)</h3>
<p>Enable it in the header (Dyntopo checkbox). Now the brush adds polygons only where you paint, automatically. Set <b>Detail Size</b> smaller for finer strokes. Great for sketching shapes with Snake Hook; the downside is messy triangle topology.</p>
<h3>Multiresolution modifier (for fine details)</h3>
<p>Add <b>Multires</b> in the Modifiers tab and click <b>Subdivide</b> a few times. You keep a simple base mesh but sculpt fine details (skin pores, scales, fabric) on the higher levels. You can go back to a lower level to change big shapes without losing the details.</p>
<h3>Which one when?</h3>
<table class="tabela">
<tr><th>Stage</th><th>Use</th></tr>
<tr><td>Blocking out the shape</td><td>Voxel Remesh (big voxels) or Dyntopo</td></tr>
<tr><td>Medium forms</td><td>Voxel Remesh with smaller voxels</td></tr>
<tr><td>Fine details on a finished shape</td><td>Multires</td></tr>
</table>
<div class="nasvet">Watch the polygon count (Overlays &rarr; Statistics). A few hundred thousand faces is fine on most computers. If Blender gets slow, use a bigger voxel size.</div>
<h3>Try it</h3>
<p>Sculpt a cartoon head: a sphere, Remesh with voxel 0.05, Grab for the jaw, Snake Hook for the ears, Remesh again with 0.02, then Crease for the eyes and mouth.</p>', 'img/lekcije/gif_kiparjenje.gif', 2),

(6, 'Project 1: Coffee Mug', '<p><b>What you build:</b> a smooth coffee mug with a handle and coffee inside. <b>You practice:</b> adding objects, the Adjust Last Operation panel, inset, extrude, Subdivision Surface, support loops, materials. <b>Time:</b> about 30 minutes.</p>
<p class="nasvet">Every step shows what your screen should look like. Orange = what you have selected at that moment. Stuck? Compare with the finished file: <a href="files/mug_finished.blend" download>mug_finished.blend</a> (made in Blender 5.0).</p>
<div class="korak-projekta"><div class="korak-st">1</div><div class="korak-vsebina"><h3>Add a cylinder</h3>
<ol><li>Start a new file (File &rarr; New &rarr; General). Click the cube and press <kbd>X</kbd> &rarr; Delete.</li>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cylinder</b>.</li>
<li>Open the <b>Adjust Last Operation</b> panel in the bottom-left corner and set <b>Vertices: 24</b>, <b>Radius: 1 m</b>, <b>Depth: 2 m</b>, <b>Location Z: 1 m</b> (so it stands on the floor).</li></ol><img class="slika-koraka" src="img/projekti/mug_1.jpg" alt="Step 1: Add a cylinder" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">2</div><div class="korak-vsebina"><h3>Inset the top face</h3>
<ol><li>Press <kbd>Tab</kbd> for Edit Mode, then <kbd>3</kbd> for face select.</li>
<li>Click the <b>top face</b> to select only it (it turns orange).</li>
<li>Press <kbd>I</kbd>, type <kbd>0</kbd><kbd>.</kbd><kbd>1</kbd><kbd>5</kbd> and press <kbd>Enter</kbd>. A ring appears: that will be the rim (wall thickness) of the mug.</li></ol><img class="slika-koraka" src="img/projekti/mug_2.jpg" alt="Step 2: Inset the top face" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">3</div><div class="korak-vsebina"><h3>Extrude down to hollow it out</h3>
<ol><li>Keep the inner face selected. Press <kbd>E</kbd>, type <kbd>-</kbd><kbd>1</kbd><kbd>.</kbd><kbd>8</kbd>, press <kbd>Enter</kbd>.</li>
<li>The face moves 1.8 m down into the mug. The mug is now hollow with a 0.2 m thick bottom.</li>
<li>Orbit (middle mouse) and look inside to check.</li></ol><img class="slika-koraka" src="img/projekti/mug_3.jpg" alt="Step 3: Extrude down to hollow it out" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">4</div><div class="korak-vsebina"><h3>Make it smooth</h3>
<ol><li>Press <kbd>Tab</kbd> to go back to Object Mode.</li>
<li>Press <kbd>Ctrl</kbd>+<kbd>2</kbd>. This adds a <b>Subdivision Surface</b> modifier with level 2 (you can see it in the wrench tab).</li>
<li>Right click &rarr; <b>Shade Smooth</b>.</li>
<li>The mug is smooth now, but it looks soft and blobby like a bowl. The next step fixes that.</li></ol><img class="slika-koraka" src="img/projekti/mug_4.jpg" alt="Step 4: Make it smooth" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">5</div><div class="korak-vsebina"><h3>Add support loops for crisp edges</h3>
<ol><li><kbd>Tab</kbd> into Edit Mode. Press <kbd>Ctrl</kbd>+<kbd>R</kbd> and hover over a vertical edge on the <b>outside</b> wall. Left click, then slide the yellow line close to the <b>top</b> and left click again.</li>
<li>Do the same for a loop close to the <b>bottom</b> of the outside wall.</li>
<li>Look into the mug and add two more loop cuts on the <b>inside</b> wall: one near the rim and one near the inner bottom.</li>
<li><kbd>Tab</kbd> back. The walls are now straight and the edges are only slightly rounded, like a real mug.</li></ol><img class="slika-koraka" src="img/projekti/mug_5.jpg" alt="Step 5: Add support loops for crisp edges" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">6</div><div class="korak-vsebina"><h3>Add the handle</h3>
<ol><li>In Object Mode press <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Torus</b>.</li>
<li>In Adjust Last Operation set <b>Major Radius 0.55</b>, <b>Minor Radius 0.1</b>, <b>Location X 1.52</b>, <b>Z 1</b> and <b>Rotation X 90&deg;</b>. The ring now stands upright on the side of the mug.</li>
<li>Press <kbd>S</kbd> <kbd>Z</kbd> <kbd>1</kbd><kbd>.</kbd><kbd>2</kbd><kbd>5</kbd> <kbd>Enter</kbd> to make it a bit taller, then right click &rarr; <b>Shade Smooth</b>.</li>
<li>Check from the top view (<kbd>Numpad 7</kbd>) that the handle does not poke into the inside of the mug. If it does, move it out a little with <kbd>G</kbd> <kbd>X</kbd>.</li></ol><img class="slika-koraka" src="img/projekti/mug_6.jpg" alt="Step 6: Add the handle" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">7</div><div class="korak-vsebina"><h3>Coffee and materials</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Circle</b>. In Adjust Last Operation set <b>Radius 0.86</b>, <b>Fill Type: N-Gon</b> and <b>Location Z 1.6</b>. This is the coffee surface.</li>
<li>Select the mug, Material tab &rarr; <b>New</b>, name it <code>Ceramic</code>, choose a Base Color and set <b>Roughness 0.15</b>.</li>
<li>Select the handle, click the sphere dropdown in the Material tab and pick <b>Ceramic</b>, so both use the same material.</li>
<li>Select the coffee circle &rarr; New material <code>Coffee</code>: very dark brown, Roughness 0.05 (shiny liquid).</li>
<li>Press <kbd>Z</kbd> &rarr; Material Preview to check.</li></ol><img class="slika-koraka" src="img/projekti/mug_7.jpg" alt="Step 7: Coffee and materials" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">8</div><div class="korak-vsebina"><h3>Light, camera, render</h3>
<ol><li>Add a floor: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Plane, <kbd>S</kbd> <kbd>2</kbd><kbd>0</kbd> <kbd>Enter</kbd>, give it a wood-colored material.</li>
<li>Delete the default light and add an <b>Area</b> light, Power 600 W, Size 4 m, above and to the side of the mug.</li>
<li>Find a nice view, then <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd> to move the camera there.</li>
<li>Render tab: Cycles, Max Samples 128. Press <kbd>F12</kbd> and save with Image &rarr; Save As.</li></ol><img class="slika-koraka" src="img/projekti/mug_8.jpg" alt="Step 8: Light, camera, render" loading="lazy"></div></div>
<h3>Bonus challenge</h3>
<p>Unwrap the mug and paint a stripe or your name on it, using the Texture Painting lesson.</p>
<p>When you are happy, mark this lesson as done and upload your render to the <a href="galerija.php">gallery</a>!</p>', 'img/projekti/mug_8.jpg', 1),

(6, 'Project 2: Little House', '<p><b>What you build:</b> a small low-poly house with a gable roof, a door, two windows and a chimney. <b>You practice:</b> scaling in Edit Mode, extrude, scaling to zero, merge by distance, loop cuts, inset, material slots. <b>Time:</b> about 30 minutes.</p>
<p class="nasvet">Orange = what is selected in that step. Finished file to compare: <a href="files/house_finished.blend" download>house_finished.blend</a> (made in Blender 5.0).</p>
<div class="korak-projekta"><div class="korak-st">1</div><div class="korak-vsebina"><h3>Shape the walls</h3>
<ol><li>New file (File &rarr; New &rarr; General). Select the cube and press <kbd>Tab</kbd> for Edit Mode.</li>
<li><kbd>A</kbd> to select everything, then <kbd>S</kbd> <kbd>X</kbd> <kbd>1</kbd><kbd>.</kbd><kbd>5</kbd> <kbd>Enter</kbd>. The house is now 3 m wide.</li>
<li><kbd>G</kbd> <kbd>Z</kbd> <kbd>1</kbd> <kbd>Enter</kbd> moves it up so it stands on the floor.</li></ol>
<p>Because we scaled in Edit Mode, the object scale stays 1 and later tools work evenly.</p><img class="slika-koraka" src="img/projekti/house_1.jpg" alt="Step 1: Shape the walls" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">2</div><div class="korak-vsebina"><h3>Extrude the top face</h3>
<ol><li>Press <kbd>3</kbd> (face select) and click the <b>top face</b>.</li>
<li><kbd>E</kbd> <kbd>1</kbd> <kbd>Enter</kbd>. The top face goes 1 m up, making the walls of the attic.</li></ol><img class="slika-koraka" src="img/projekti/house_2.jpg" alt="Step 2: Extrude the top face" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">3</div><div class="korak-vsebina"><h3>Turn it into a roof</h3>
<ol><li>With the top face still selected, press <kbd>S</kbd> <kbd>Y</kbd> <kbd>0</kbd> <kbd>Enter</kbd>. The face is squashed to a line, the ridge of the roof, and the front and back become slopes.</li>
<li>Now there are doubled vertices on the ridge. Press <kbd>A</kbd>, then <kbd>M</kbd> &rarr; <b>By Distance</b>. The info bar says "Removed 2 vertice(s)".</li></ol><img class="slika-koraka" src="img/projekti/house_3.jpg" alt="Step 3: Turn it into a roof" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">4</div><div class="korak-vsebina"><h3>Loop cuts for the door and windows</h3>
<ol><li><kbd>Ctrl</kbd>+<kbd>R</kbd>, hover over the bottom front edge (the horizontal one). Scroll the wheel up once so you see <b>2</b> yellow lines, left click, then <b>right click</b> so they stay evenly spaced.</li>
<li><kbd>Ctrl</kbd>+<kbd>R</kbd> again, hover over a vertical edge of the front wall, left click and right click. One horizontal loop goes around the house at half height.</li>
<li>The front wall now has 6 faces: 3 at the bottom, 3 at the top.</li></ol><img class="slika-koraka" src="img/projekti/house_4.jpg" alt="Step 4: Loop cuts for the door and windows" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">5</div><div class="korak-vsebina"><h3>Make the door</h3>
<ol><li>Click the <b>bottom middle</b> face of the front wall.</li>
<li><kbd>I</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>0</kbd><kbd>8</kbd> <kbd>Enter</kbd> for a door frame.</li>
<li><kbd>E</kbd> <kbd>-</kbd><kbd>0</kbd><kbd>.</kbd><kbd>1</kbd> <kbd>Enter</kbd> pushes the door into the wall.</li></ol><img class="slika-koraka" src="img/projekti/house_5.jpg" alt="Step 5: Make the door" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">6</div><div class="korak-vsebina"><h3>Make two windows</h3>
<ol><li>Click the <b>top left</b> face of the front wall, <kbd>Shift</kbd>+click the <b>top right</b> face.</li>
<li><kbd>I</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>1</kbd><kbd>2</kbd> <kbd>Enter</kbd>. Each window gets its own frame because the faces do not touch.</li>
<li><kbd>E</kbd> <kbd>-</kbd><kbd>0</kbd><kbd>.</kbd><kbd>0</kbd><kbd>8</kbd> <kbd>Enter</kbd> to push the glass in.</li></ol><img class="slika-koraka" src="img/projekti/house_6.jpg" alt="Step 6: Make two windows" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">7</div><div class="korak-vsebina"><h3>Materials with slots, and a chimney</h3>
<ol><li>Material tab &rarr; <b>New</b> &rarr; name it <code>Wall</code>, light beige color. It covers the whole house.</li>
<li>Click <b>+</b> to add a second slot &rarr; New &rarr; <code>Roof</code>, red. Select the two roof faces (<kbd>Shift</kbd>+click), select the Roof slot, click <b>Assign</b>.</li>
<li>Repeat for <code>Door</code> (dark brown) on the door face and <code>Glass</code> on the two window faces. For glowing windows set Emission Color to warm yellow and Emission Strength to 3.</li>
<li><kbd>Tab</kbd> to Object Mode. <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Cube, then in Adjust Last Operation set Location X 0.8, Y -0.4, Z 2.55. Press <kbd>S</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>2</kbd> <kbd>Enter</kbd>, then <kbd>S</kbd> <kbd>Z</kbd> <kbd>2</kbd> <kbd>Enter</kbd> and give it the Wall material.</li></ol><img class="slika-koraka" src="img/projekti/house_7.jpg" alt="Step 7: Materials with slots, and a chimney" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">8</div><div class="korak-vsebina"><h3>Grass, sun and render</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Plane, <kbd>S</kbd> <kbd>3</kbd><kbd>0</kbd> <kbd>Enter</kbd>, green material with Roughness 0.8.</li>
<li>Replace the default light with a <b>Sun</b>, Strength 3.5, rotated so the shadow falls diagonally.</li>
<li>World tab: set the Color to light blue for a sky.</li>
<li>Optional: add a <b>Bevel</b> modifier to the house (Amount 0.02 m, Segments 2) for softer edges.</li>
<li>Place the camera (<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd>) and render with <kbd>F12</kbd>.</li></ol><img class="slika-koraka" src="img/projekti/house_8.jpg" alt="Step 8: Grass, sun and render" loading="lazy"></div></div>
<h3>Bonus challenge</h3>
<p>Add trees from a cylinder and cones, a path from a flattened cube, or use an Array modifier for a fence.</p>
<p>Upload your house to the <a href="galerija.php">gallery</a> when you finish the module!</p>', 'img/projekti/house_8.jpg', 2),

(6, 'Project 3: Snowman', '<p><b>What you build:</b> a snowman with a carrot nose, coal eyes and buttons and a top hat, in a snowy scene. <b>You practice:</b> UV spheres, duplicating, typed positions in the Adjust panel, materials, the Sun light and the camera. <b>Time:</b> about 25 minutes. This one is the easiest, a good first project.</p>
<p class="nasvet">Orange = the new parts in that step. Finished file to compare: <a href="files/snowman_finished.blend" download>snowman_finished.blend</a> (made in Blender 5.0).</p>
<div class="korak-projekta"><div class="korak-st">1</div><div class="korak-vsebina"><h3>The bottom snowball</h3>
<ol><li>New file, delete the cube (<kbd>X</kbd>).</li>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>UV Sphere</b>. In Adjust Last Operation set <b>Radius 1 m</b> and <b>Location Z 1 m</b>.</li>
<li>Right click &rarr; <b>Shade Smooth</b>.</li></ol><img class="slika-koraka" src="img/projekti/snowman_1.jpg" alt="Step 1: The bottom snowball" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">2</div><div class="korak-vsebina"><h3>Middle ball and head</h3>
<ol><li>With the ball selected press <kbd>Shift</kbd>+<kbd>D</kbd>, then <kbd>Z</kbd> <kbd>1</kbd><kbd>.</kbd><kbd>4</kbd> <kbd>Enter</kbd>. The copy moves 1.4 m up.</li>
<li><kbd>S</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>7</kbd><kbd>2</kbd> <kbd>Enter</kbd> makes it smaller.</li>
<li>Duplicate the middle ball: <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Z</kbd> <kbd>1</kbd> <kbd>Enter</kbd>, then <kbd>S</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>7</kbd> <kbd>Enter</kbd>. That is the head.</li>
<li>Look from the front (<kbd>Numpad 1</kbd>): the balls should overlap a little.</li></ol><img class="slika-koraka" src="img/projekti/snowman_2.jpg" alt="Step 2: Middle ball and head" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">3</div><div class="korak-vsebina"><h3>Nose, eyes and buttons</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cone</b>. In Adjust Last Operation: <b>Radius 1 = 0.08</b>, <b>Radius 2 = 0</b>, <b>Depth 0.4</b>, <b>Location Y -0.5, Z 3.4</b>, <b>Rotation X 90&deg;</b>. The carrot now points forward.</li>
<li>Eye: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; UV Sphere with <b>Radius 0.05</b>, <b>Location X -0.17, Y -0.44, Z 3.55</b>. Duplicate it with <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>X</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>3</kbd><kbd>4</kbd> <kbd>Enter</kbd> for the second eye.</li>
<li>Buttons: a UV Sphere with Radius 0.06 at <b>Y -0.67, Z 2.65</b>, then duplicate it down twice with <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Z</kbd> <kbd>-</kbd><kbd>0</kbd><kbd>.</kbd><kbd>3</kbd> <kbd>Enter</kbd>. Move each one with <kbd>G</kbd> <kbd>Y</kbd> until it just touches the body (check in the side view <kbd>Numpad 3</kbd>).</li>
<li>Select all the small parts and right click &rarr; Shade Smooth.</li></ol><img class="slika-koraka" src="img/projekti/snowman_3.jpg" alt="Step 3: Nose, eyes and buttons" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">4</div><div class="korak-vsebina"><h3>Top hat</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cylinder</b>: Radius 0.55, Depth 0.05, Location Z 3.78. That is the brim.</li>
<li>Another Cylinder: Radius 0.35, Depth 0.55, Location Z 4.05. That is the top.</li></ol><img class="slika-koraka" src="img/projekti/snowman_4.jpg" alt="Step 4: Top hat" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">5</div><div class="korak-vsebina"><h3>Materials</h3>
<ol><li>Select a snowball &rarr; Material tab &rarr; New &rarr; <code>Snow</code>: almost white (not pure white), Roughness 0.5. Give the other two balls the same material from the dropdown.</li>
<li><code>Coal</code>: near black, Roughness 0.4, for eyes, buttons and both hat parts.</li>
<li><code>Carrot</code>: orange, Roughness 0.45, for the nose.</li>
<li>Tip: select all objects that need the same material, then select the one that already has it last (it becomes active) and press <kbd>Ctrl</kbd>+<kbd>L</kbd> &rarr; <b>Link Materials</b>.</li></ol><img class="slika-koraka" src="img/projekti/snowman_5.jpg" alt="Step 5: Materials" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">6</div><div class="korak-vsebina"><h3>Snowy scene and render</h3>
<ol><li>Plane for the ground: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Plane, <kbd>S</kbd> <kbd>4</kbd><kbd>0</kbd>, with the Snow material.</li>
<li>Replace the light with a <b>Sun</b>, Strength 3, slightly warm color. World color: light grey-blue for a winter sky.</li>
<li>Camera: <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd> from a nice view, Focal Length 40 mm.</li>
<li><kbd>F12</kbd> and Image &rarr; Save As.</li></ol><img class="slika-koraka" src="img/projekti/snowman_6.jpg" alt="Step 6: Snowy scene and render" loading="lazy"></div></div>
<h3>Bonus challenge</h3>
<p>Add stick arms from thin cylinders, a scarf from a torus (scale it flat with <kbd>S</kbd> <kbd>Z</kbd>), or sculpt the snowballs to look less perfect with the Sculpt Mode Grab brush.</p>', 'img/projekti/snowman_6.jpg', 3),

(6, 'Project 4: Cute Cottage', '<p><b>What you build:</b> this cute cottage with a tiled roof, a chimney with smoke puffs, an arched door, windows, steps, a path and two low-poly trees, standing on a grass platform. <b>You practice:</b> exact sizes in the Sidebar, applying scale, the Bevel and Array modifiers, Join, Mirror-style duplicates, material colors with hex codes. <b>Time:</b> about 60&ndash;90 minutes.</p>
<p class="nasvet">Orange = the new parts in that step. All sizes are in meters and copied from the original model, so your cottage will match it. Finished file to compare: <a href="files/cute_house_finished.blend" download>cute_house_finished.blend</a> (made in Blender 5.0).</p>
<h3>The method for every box (read this first)</h3>
<p>Almost every part of this cottage is a box. You make each box the same way:</p>
<ol>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cube</b>.</li>
<li>Press <kbd>N</kbd> to open the Sidebar, <b>Item</b> tab. Type the <b>Location</b> and the <b>Dimensions</b> from the table in the step (click a field, type, press <kbd>Tab</kbd> to go to the next field). If the table gives a Rotation, type it too.</li>
<li>Press <kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; <b>Scale</b>. Typing Dimensions changed the scale, and this resets it to 1 so bevels and arrays are not stretched.</li>
<li>If the table gives a <b>Bevel</b> value: Properties &rarr; Modifiers (wrench) &rarr; <b>Add Modifier &rarr; Generate &rarr; Bevel</b>. Set <b>Amount</b> to that value and <b>Segments</b> to 3. Then right click &rarr; <b>Shade Auto Smooth</b>. This gives the soft, toy-like edges.</li>
<li>Press <kbd>F2</kbd> and give the part a name (Walls, Roof_Left, ...). With 40 parts, names in the Outliner help a lot.</li>
</ol>
<p>Delete the default cube, camera and light before you start (<kbd>A</kbd>, <kbd>X</kbd>). We add a new light and camera at the end.</p>
<div class="korak-projekta"><div class="korak-st">1</div><div class="korak-vsebina"><h3>Grass platform</h3><table class="tabela"><tr><th>Part</th><th>Location X, Y, Z</th><th>Dimensions X, Y, Z</th><th>Bevel</th></tr><tr><td>Grass</td><td><code>0, -0.05, 0.075</code></td><td><code>3.4, 3.3, 0.15</code></td><td>0.05</td></tr></table>
<p>Everything else stands on top of this platform, which is 0.15 m high. Look from the front (<kbd>Numpad 1</kbd>) to see that its bottom sits exactly on the red/green floor grid.</p><img class="slika-koraka" src="img/projekti/cute_1.jpg" alt="Step 1: Grass platform" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">2</div><div class="korak-vsebina"><h3>Walls and the blue plinth</h3><table class="tabela"><tr><th>Part</th><th>Location X, Y, Z</th><th>Dimensions X, Y, Z</th><th>Bevel</th></tr><tr><td>Walls</td><td><code>0, 0.1, 0.85</code></td><td><code>1.6, 1.4, 1.4</code></td><td>0.04</td></tr><tr><td>Plinth</td><td><code>0, 0.1, 0.25</code></td><td><code>1.66, 1.46, 0.2</code></td><td>0.03</td></tr></table>
<p>The plinth is a little bigger than the walls, so it sticks out 3 cm all around like a skirting board.</p><img class="slika-koraka" src="img/projekti/cute_2.jpg" alt="Step 2: Walls and the blue plinth" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">3</div><div class="korak-vsebina"><h3>The gable (triangle under the roof)</h3><table class="tabela"><tr><th>Part</th><th>Location X, Y, Z</th><th>Dimensions X, Y, Z</th><th>Bevel</th></tr><tr><td>Gable</td><td><code>0, 0.1, 1.92</code></td><td><code>1.58, 1.38, 0.76</code></td><td>-</td></tr></table>
<ol><li>Make the box and apply the scale (<kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale).</li>
<li><kbd>Tab</kbd> into Edit Mode, press <kbd>3</kbd> and click the <b>top face</b>.</li>
<li><kbd>S</kbd> <kbd>X</kbd> <kbd>0</kbd> <kbd>Enter</kbd>. The top face shrinks to a line in the middle and the box becomes a triangle prism.</li>
<li><kbd>A</kbd>, then <kbd>M</kbd> &rarr; <b>By Distance</b> to merge the doubled vertices. <kbd>Tab</kbd> back to Object Mode.</li></ol><img class="slika-koraka" src="img/projekti/cute_3.jpg" alt="Step 3: The gable (triangle under the roof)" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">4</div><div class="korak-vsebina"><h3>Two roof slabs</h3><table class="tabela"><tr><th>Part</th><th>Location X, Y, Z</th><th>Dimensions X, Y, Z</th><th>Bevel</th></tr><tr><td>Roof_Left</td><td><code>-0.51, 0.1, 1.91</code></td><td><code>1.36, 1.74, 0.12</code></td><td>0.03</td></tr></table>
<ol><li>Make the box like usual, but also type <b>Rotation Y: -44</b> in the Sidebar. The slab tilts and lies on the left side of the gable.</li>
<li>Apply only the scale (<kbd>Ctrl</kbd>+<kbd>A</kbd> &rarr; Scale), add the Bevel.</li>
<li>For the right side press <kbd>Shift</kbd>+<kbd>D</kbd>, then <b>right click</b> so the copy stays in place. In the Sidebar change <b>Location X</b> to <b>0.51</b> and <b>Rotation Y</b> to <b>44</b>. The copy keeps its bevel.</li></ol>
<p>The slabs overhang the walls on every side, which makes the cottage look cute and chunky.</p><img class="slika-koraka" src="img/projekti/cute_4.jpg" alt="Step 4: Two roof slabs" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">5</div><div class="korak-vsebina"><h3>Shingles with the Array modifier, and the ridge</h3><table class="tabela"><tr><th>Part</th><th>Location X, Y, Z</th><th>Dimensions X, Y, Z</th><th>Bevel</th></tr><tr><td>Shingles_Left</td><td><code>-0.911, 0.1, 1.637</code></td><td><code>0.24, 1.68, 0.04</code></td><td>0.015 (2 segments)</td></tr></table>
<ol><li>Make one shingle strip with <b>Rotation Y: -44</b> (the same tilt as the roof) and apply the scale. It sits at the bottom edge of the left roof slab.</li>
<li>Add Modifier &rarr; Generate &rarr; <b>Array</b>. Set <b>Count: 4</b>. Untick <b>Relative Offset</b>, tick <b>Constant Offset</b> and set its <b>Distance X</b> to <b>0.27</b>. Four strips climb up the roof, following the tilt.</li>
<li>Then add the Bevel (Amount 0.015, Segments 2). The Array must be <b>above</b> the Bevel in the modifier list.</li>
<li>Right side: <kbd>Shift</kbd>+<kbd>D</kbd>, right click, set <b>Location X 0.911</b>, <b>Rotation Y 44</b>, and in the Array change <b>Distance X</b> to <b>-0.27</b>.</li>
<li>Ridge: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cylinder</b>. In Adjust Last Operation: <b>Radius 0.06</b>, <b>Depth 1.74</b>, <b>Location 0, 0.1, 2.44</b>, <b>Rotation X 90</b>. Right click &rarr; Shade Smooth.</li></ol><img class="slika-koraka" src="img/projekti/cute_5.jpg" alt="Step 5: Shingles with the Array modifier, and the ridge" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">6</div><div class="korak-vsebina"><h3>Chimney with smoke puffs</h3><table class="tabela"><tr><th>Part</th><th>Location X, Y, Z</th><th>Dimensions X, Y, Z</th><th>Bevel</th></tr><tr><td>Chimney</td><td><code>0.42, 0.42, 2.13</code></td><td><code>0.26, 0.26, 0.62</code></td><td>0.015</td></tr><tr><td>Chimney_Cap</td><td><code>0.42, 0.42, 2.48</code></td><td><code>0.34, 0.34, 0.08</code></td><td>0.015</td></tr><tr><td>Chimney_Bands</td><td><code>0.42, 0.42, 2.04</code></td><td><code>0.28, 0.28, 0.025</code></td><td>-</td></tr><tr><td>Smoke_1</td><td><code>0.44, 0.42, 2.66</code></td><td><code>0.08, 0.08, 0.08</code></td><td>0.015</td></tr><tr><td>Smoke_2</td><td><code>0.5, 0.42, 2.8</code></td><td><code>0.05, 0.05, 0.05</code></td><td>0.01</td></tr></table>
<p>The chimney starts inside the roof, so you only see the top part. For the three blue bands make one thin band, apply the scale, then add an <b>Array</b> with <b>Count 3</b>, Relative Offset off, Constant Offset on and <b>Distance Z 0.12</b>.</p><img class="slika-koraka" src="img/projekti/cute_6.jpg" alt="Step 6: Chimney with smoke puffs" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">7</div><div class="korak-vsebina"><h3>Arched door and mailbox</h3><table class="tabela"><tr><th>Part</th><th>Location X, Y, Z</th><th>Dimensions X, Y, Z</th><th>Bevel</th></tr><tr><td>Door_Frame (box)</td><td><code>0, -0.62, 0.595</code></td><td><code>0.58, 0.06, 0.59</code></td><td>-</td></tr><tr><td>Door (box)</td><td><code>0, -0.645, 0.58</code></td><td><code>0.44, 0.05, 0.56</code></td><td>-</td></tr><tr><td>Door_Window</td><td><code>0, -0.675, 0.895</code></td><td><code>0.12, 0.01, 0.17</code></td><td>-</td></tr><tr><td>Mailbox</td><td><code>0.52, -0.63, 0.77</code></td><td><code>0.2, 0.06, 0.06</code></td><td>0.01</td></tr></table>
<ol><li>An arch is a box with a cylinder on top. After the frame box, add a <b>Cylinder</b> with <b>Radius 0.29</b>, <b>Depth 0.055</b>, <b>Location 0, -0.62, 0.89</b>, <b>Rotation X 90</b>. Its center is exactly on the top edge of the box, so the round half sticks out above it.</li>
<li>Select the cylinder, <kbd>Shift</kbd>+click the frame box, press <kbd>Ctrl</kbd>+<kbd>J</kbd> to join them into one object.</li>
<li>Same for the door itself: the door box, then a Cylinder with <b>Radius 0.22</b>, <b>Depth 0.045</b>, <b>Location 0, -0.645, 0.86</b>, <b>Rotation X 90</b>, and join.</li>
<li>The cylinders are a little thinner than the boxes on purpose. If two faces lie exactly on top of each other you get flickering black spots (called z-fighting).</li>
<li>Knob: <b>UV Sphere</b> with <b>Radius 0.025</b> at <b>0.145, -0.69, 0.67</b>, Shade Smooth.</li></ol><img class="slika-koraka" src="img/projekti/cute_7.jpg" alt="Step 7: Arched door and mailbox" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">8</div><div class="korak-vsebina"><h3>Steps and a stone path</h3><table class="tabela"><tr><th>Part</th><th>Location X, Y, Z</th><th>Dimensions X, Y, Z</th><th>Bevel</th></tr><tr><td>Step_Upper</td><td><code>0, -0.69, 0.23</code></td><td><code>0.58, 0.18, 0.16</code></td><td>0.015</td></tr><tr><td>Step_Lower</td><td><code>0, -0.77, 0.19</code></td><td><code>0.72, 0.34, 0.08</code></td><td>0.015</td></tr><tr><td>Stone_1</td><td><code>0, -1.02, 0.165</code></td><td><code>0.5, 0.24, 0.03</code></td><td>0.01</td></tr></table>
<p>For the other two stones select Stone_1 and press <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Y</kbd> <kbd>-</kbd><kbd>0</kbd><kbd>.</kbd><kbd>3</kbd><kbd>1</kbd> <kbd>Enter</kbd>, then <kbd>G</kbd> <kbd>X</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>0</kbd><kbd>4</kbd> <kbd>Enter</kbd>. Duplicate that one again by <kbd>Y</kbd> -0.31 and move it <kbd>X</kbd> -0.06. The small sideways shifts make the path look hand-made.</p><img class="slika-koraka" src="img/projekti/cute_8.jpg" alt="Step 8: Steps and a stone path" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">9</div><div class="korak-vsebina"><h3>Side window</h3><table class="tabela"><tr><th>Part</th><th>Location X, Y, Z</th><th>Dimensions X, Y, Z</th><th>Bevel</th></tr><tr><td>Glass</td><td><code>0.805, 0.05, 0.97</code></td><td><code>0.02, 0.5, 0.5</code></td><td>-</td></tr><tr><td>Frame_Bottom</td><td><code>0.82, 0.05, 0.72</code></td><td><code>0.04, 0.56, 0.06</code></td><td>-</td></tr><tr><td>Frame_Top</td><td><code>0.82, 0.05, 1.22</code></td><td><code>0.04, 0.56, 0.06</code></td><td>-</td></tr><tr><td>Frame_Left</td><td><code>0.82, -0.2, 0.97</code></td><td><code>0.04, 0.06, 0.44</code></td><td>-</td></tr><tr><td>Frame_Right</td><td><code>0.82, 0.3, 0.97</code></td><td><code>0.04, 0.06, 0.44</code></td><td>-</td></tr><tr><td>Bar_Horizontal</td><td><code>0.82, 0.05, 0.97</code></td><td><code>0.04, 0.44, 0.04</code></td><td>-</td></tr><tr><td>Bar_Vertical</td><td><code>0.82, 0.05, 0.97</code></td><td><code>0.035, 0.04, 0.44</code></td><td>-</td></tr><tr><td>Sill</td><td><code>0.84, 0.05, 0.67</code></td><td><code>0.1, 0.66, 0.04</code></td><td>0.01</td></tr></table>
<p>The window is on the right wall (the +X side). Faster than typing every part: make Frame_Bottom, then <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Z</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>5</kbd> <kbd>Enter</kbd> for Frame_Top. Make Frame_Left, then <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>Y</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>5</kbd> <kbd>Enter</kbd> for Frame_Right. The side bars are shorter (0.44) so they fit between the top and bottom bars without overlapping.</p><img class="slika-koraka" src="img/projekti/cute_9.jpg" alt="Step 9: Side window" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">10</div><div class="korak-vsebina"><h3>Round attic window</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Torus</b>. In Adjust Last Operation: <b>Major Radius 0.17</b>, <b>Minor Radius 0.025</b>, <b>Location 0, -0.61, 1.83</b>, <b>Rotation X 90</b>. Shade Smooth.</li>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Circle</b>: <b>Radius 0.15</b>, <b>Fill Type: N-Gon</b>, <b>Location 0, -0.6, 1.83</b>, <b>Rotation X 90</b>. That is the glass.</li></ol><img class="slika-koraka" src="img/projekti/cute_10.jpg" alt="Step 10: Round attic window" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">11</div><div class="korak-vsebina"><h3>Two low-poly trees</h3>
<ol><li>Trunk: <kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Mesh &rarr; <b>Cylinder</b> with <b>Vertices 8</b>, <b>Radius 0.09</b>, <b>Depth 0.5</b>, <b>Location -1.25, -0.45, 0.4</b>.</li>
<li>Big crown: <b>Ico Sphere</b> with <b>Subdivisions 1</b>, <b>Radius 0.35</b>, <b>Location -1.25, -0.45, 0.88</b>.</li>
<li>Small crown: Ico Sphere, <b>Subdivisions 1</b>, <b>Radius 0.22</b>, <b>Location -1.16, -0.41, 1.16</b>.</li>
<li>Do <b>not</b> use Shade Smooth here: the flat faces are what makes it low-poly.</li>
<li>Second tree: select all three parts, <kbd>Shift</kbd>+<kbd>D</kbd> <kbd>X</kbd> <kbd>2</kbd><kbd>.</kbd><kbd>4</kbd><kbd>5</kbd> <kbd>Enter</kbd>, then <kbd>G</kbd> <kbd>Y</kbd> <kbd>1</kbd><kbd>.</kbd><kbd>5</kbd> <kbd>Enter</kbd>, <kbd>S</kbd> <kbd>0</kbd><kbd>.</kbd><kbd>8</kbd><kbd>6</kbd> <kbd>Enter</kbd> and <kbd>R</kbd> <kbd>Z</kbd> <kbd>4</kbd><kbd>5</kbd> <kbd>Enter</kbd>. A smaller, turned copy looks more natural than an exact copy.</li></ol><img class="slika-koraka" src="img/projekti/cute_11.jpg" alt="Step 11: Two low-poly trees" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">12</div><div class="korak-vsebina"><h3>Colors</h3>
<p>Make these 12 materials (Material tab &rarr; New, rename it, set Base Color and Roughness). To type a color, click the Base Color swatch, choose the <b>Hex</b> tab and paste the code.</p>
<table class="tabela"><tr><th>Material</th><th>Hex</th><th>Roughness</th><th>Use on</th></tr>
<tr><td>Grass</td><td><code>A9D57A</code></td><td>0.8</td><td>platform</td></tr>
<tr><td>Wall</td><td><code>FCEBC0</code></td><td>0.8</td><td>walls, gable</td></tr>
<tr><td>Trim</td><td><code>FBF5EA</code></td><td>0.8</td><td>chimney, cap, smoke, steps, window frames, sill, attic ring</td></tr>
<tr><td>Blue</td><td><code>B9D3CF</code></td><td>0.8</td><td>plinth, door frame, chimney bands</td></tr>
<tr><td>Roof</td><td><code>A8603A</code></td><td>0.8</td><td>roof slabs</td></tr>
<tr><td>Shingle</td><td><code>8F4E2E</code></td><td>0.8</td><td>shingles, ridge</td></tr>
<tr><td>Door</td><td><code>D99A4E</code></td><td>0.7</td><td>door, mailbox</td></tr>
<tr><td>Glass</td><td><code>CFE6EF</code></td><td>0.25</td><td>all glass</td></tr>
<tr><td>Gold</td><td><code>E8C04A</code></td><td>0.4 (Metallic 0.3)</td><td>door knob</td></tr>
<tr><td>Stone</td><td><code>ECE7DE</code></td><td>0.8</td><td>path stones</td></tr>
<tr><td>Leaves</td><td><code>8FCF6A</code></td><td>0.85</td><td>tree crowns</td></tr>
<tr><td>Trunk</td><td><code>8A5A36</code></td><td>0.9</td><td>tree trunks</td></tr>
</table>
<p>Shortcut: make the material once, then select all parts that need it, select the part that already has it <b>last</b> and press <kbd>Ctrl</kbd>+<kbd>L</kbd> &rarr; <b>Link Materials</b>.</p><img class="slika-koraka" src="img/projekti/cute_12.jpg" alt="Step 12: Colors" loading="lazy"></div></div><div class="korak-projekta"><div class="korak-st">13</div><div class="korak-vsebina"><h3>Sun, sky and render</h3>
<ol><li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Light &rarr; <b>Sun</b>. Strength <b>3.2</b>, a slightly warm color, Rotation X 48, Y 0, Z 30.</li>
<li>World tab: Color <code>CEE5F9</code> (light blue sky). The sky also lights the shadows softly.</li>
<li><kbd>Shift</kbd>+<kbd>A</kbd> &rarr; Camera. Navigate to a view from the front-right and a little above, then <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Numpad 0</kbd>. Focal Length 45 mm.</li>
<li>Render tab: Cycles, Max Samples 128 (or EEVEE for a fast result). <kbd>F12</kbd>, then Image &rarr; Save As.</li></ol><img class="slika-koraka" src="img/projekti/cute_13.jpg" alt="Step 13: Sun, sky and render" loading="lazy"></div></div>
<h3>Bonus challenge</h3>
<p>Add a fence with the Array modifier, flowers from small ico spheres, or make the windows glow at night: set the World color to dark blue and give the Glass material Emission Strength 3 with a warm yellow color.</p>
<p>Upload your cottage to the <a href="galerija.php">gallery</a> when you finish the module!</p>', 'img/projekti/cute_13.jpg', 4);

INSERT INTO bliznjica (tipka, opis, kategorija) VALUES
('Tab', 'Switch between Object Mode and Edit Mode', 'General'),
('F3', 'Search for any command', 'General'),
('Ctrl + Z', 'Undo', 'General'),
('Ctrl + Shift + Z', 'Redo', 'General'),
('Ctrl + S', 'Save the .blend file', 'General'),
('N', 'Toggle the Sidebar (exact location, rotation, scale)', 'General'),
('T', 'Toggle the Toolbar', 'General'),
('Ctrl + Space', 'Maximize the editor under the mouse', 'General'),
('Shift + A', 'Add a new object', 'General'),
('X', 'Delete menu', 'General'),
('Numpad 1 / 3 / 7', 'Front / Right / Top view', 'Navigation'),
('Numpad 5', 'Perspective / Orthographic', 'Navigation'),
('Numpad 0', 'Camera view', 'Navigation'),
('Ctrl + Alt + Numpad 0', 'Move the camera to the current view', 'Navigation'),
('Numpad .', 'Zoom to the selection', 'Navigation'),
('Home', 'Show all objects', 'Navigation'),
('~', 'View pie menu (no numpad needed)', 'Navigation'),
('Z', 'Viewport shading pie (Solid, Material Preview, Rendered)', 'Navigation'),
('Alt + Z', 'Toggle X-ray', 'Navigation'),
('G', 'Move (grab)', 'Transform'),
('R', 'Rotate', 'Transform'),
('S', 'Scale', 'Transform'),
('X / Y / Z', 'Lock the transform to an axis', 'Transform'),
('Shift + D', 'Duplicate', 'Transform'),
('Alt + G / R / S', 'Reset location / rotation / scale', 'Transform'),
('Ctrl + A', 'Apply scale / rotation', 'Transform'),
('Shift + S', 'Snap menu (cursor to selected, to world origin)', 'Transform'),
('1 / 2 / 3', 'Vertex / edge / face select (Edit Mode)', 'Modeling'),
('E', 'Extrude', 'Modeling'),
('I', 'Inset (press twice for individual faces)', 'Modeling'),
('Ctrl + R', 'Loop cut (scroll for more cuts)', 'Modeling'),
('Ctrl + B', 'Bevel edges (scroll for segments)', 'Modeling'),
('K', 'Knife', 'Modeling'),
('M', 'Merge vertices (By Distance removes doubles)', 'Modeling'),
('F', 'Fill: make an edge or face', 'Modeling'),
('Alt + Click', 'Select an edge loop', 'Modeling'),
('L', 'Select linked under the mouse', 'Modeling'),
('O', 'Proportional editing on/off', 'Modeling'),
('Ctrl + 1 / 2 / 3', 'Add Subdivision Surface level 1-3', 'Modeling'),
('Ctrl + J', 'Join objects', 'Modeling'),
('U', 'UV unwrap menu', 'Texturing'),
('Ctrl + E', 'Edge menu (Mark Seam)', 'Texturing'),
('F', 'Brush radius (paint and sculpt)', 'Texturing'),
('Shift + F', 'Brush strength (paint and sculpt)', 'Texturing'),
('S', 'Sample a color (Texture Paint)', 'Texturing'),
('Shift + Alt + S', 'Save the painted image as (Image Editor)', 'Texturing'),
('Ctrl', 'Hold to invert the brush (Sculpt)', 'Sculpting'),
('Shift', 'Hold to smooth (Sculpt)', 'Sculpting'),
('R / Ctrl + R', 'Set voxel size / Remesh (Sculpt)', 'Sculpting'),
('Alt + M', 'Clear the mask (Sculpt)', 'Sculpting'),
('Ctrl + L', 'Link materials to selected objects', 'Shading'),
('F12', 'Render an image', 'Shading'),
('Ctrl + F12', 'Render an animation', 'Shading'),
('F11', 'Show the last render', 'Shading');
