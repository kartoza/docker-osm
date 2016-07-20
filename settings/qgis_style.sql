SET XML OPTION DOCUMENT;
--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: layer_styles; Type: TABLE; Schema: public; Owner: docker; Tablespace: 
--

CREATE TABLE layer_styles (
    id integer NOT NULL,
    f_table_catalog character varying,
    f_table_schema character varying,
    f_table_name character varying,
    f_geometry_column character varying,
    stylename character varying(30),
    styleqml xml,
    stylesld xml,
    useasdefault boolean,
    description text,
    owner character varying(30),
    ui xml,
    update_time timestamp without time zone DEFAULT now()
);


ALTER TABLE layer_styles OWNER TO docker;

--
-- Name: layer_styles_id_seq; Type: SEQUENCE; Schema: public; Owner: docker
--

CREATE SEQUENCE layer_styles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE layer_styles_id_seq OWNER TO docker;

--
-- Name: layer_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: docker
--

ALTER SEQUENCE layer_styles_id_seq OWNED BY layer_styles.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: docker
--

ALTER TABLE ONLY layer_styles ALTER COLUMN id SET DEFAULT nextval('layer_styles_id_seq'::regclass);


--
-- Data for Name: layer_styles; Type: TABLE DATA; Schema: public; Owner: docker
--

INSERT INTO layer_styles VALUES (1, 'gis', 'public', 'osm_waterareas', 'geometry', 'waterares', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="2.12.2-Lyon" minimumScale="0" maximumScale="1e+08" simplifyDrawingHints="1" minLabelScale="0" maxLabelScale="1e+08" simplifyDrawingTol="1" simplifyMaxScale="1" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" scaleBasedLabelVisibilityFlag="0">
 <edittypes>
  <edittype widgetv2type="TextEdit" name="id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="osm_id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="name">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="type">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="area">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
 </edittypes>
 <renderer-v2 attr="type" forceraster="0" symbollevels="0" type="categorizedSymbol">
  <categories>
   <category render="true" symbol="0" value="basin" label="basin"/>
   <category render="true" symbol="1" value="reservoir" label="reservoir"/>
   <category render="true" symbol="2" value="riverbank" label="riverbank"/>
   <category render="true" symbol="3" value="swimming_pool" label="swimming_pool"/>
   <category render="true" symbol="4" value="water" label="water"/>
   <category render="true" symbol="5" value="" label=""/>
  </categories>
  <symbols>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="0">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="165,191,221,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="114,133,132,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
    <layer pass="0" class="LinePatternFill" locked="1">
     <prop k="angle" v="45"/>
     <prop k="color" v="52,111,107,255"/>
     <prop k="distance" v="2"/>
     <prop k="distance_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="distance_unit" v="MM"/>
     <prop k="line_width" v="0.1"/>
     <prop k="line_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="line_width_unit" v="MM"/>
     <prop k="offset" v="1"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <symbol alpha="1" clip_to_extent="1" type="line" name="@0@1">
      <layer pass="0" class="SimpleLine" locked="0">
       <prop k="capstyle" v="square"/>
       <prop k="customdash" v="5;2"/>
       <prop k="customdash_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="customdash_unit" v="MM"/>
       <prop k="draw_inside_polygon" v="0"/>
       <prop k="joinstyle" v="bevel"/>
       <prop k="line_color" v="0,0,0,255"/>
       <prop k="line_style" v="no"/>
       <prop k="line_width" v="0.26"/>
       <prop k="line_width_unit" v="MM"/>
       <prop k="offset" v="0"/>
       <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="offset_unit" v="MM"/>
       <prop k="use_custom_dash" v="0"/>
       <prop k="width_map_unit_scale" v="0,0,0,0,0,0"/>
      </layer>
     </symbol>
    </layer>
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="0,0,255,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="diagonal_x"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="1">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="165,191,221,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="114,133,132,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
    <layer pass="0" class="LinePatternFill" locked="1">
     <prop k="angle" v="45"/>
     <prop k="color" v="52,111,107,255"/>
     <prop k="distance" v="2"/>
     <prop k="distance_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="distance_unit" v="MM"/>
     <prop k="line_width" v="0.1"/>
     <prop k="line_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="line_width_unit" v="MM"/>
     <prop k="offset" v="1"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <symbol alpha="1" clip_to_extent="1" type="line" name="@1@1">
      <layer pass="0" class="SimpleLine" locked="0">
       <prop k="capstyle" v="square"/>
       <prop k="customdash" v="5;2"/>
       <prop k="customdash_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="customdash_unit" v="MM"/>
       <prop k="draw_inside_polygon" v="0"/>
       <prop k="joinstyle" v="bevel"/>
       <prop k="line_color" v="0,0,0,255"/>
       <prop k="line_style" v="no"/>
       <prop k="line_width" v="0.26"/>
       <prop k="line_width_unit" v="MM"/>
       <prop k="offset" v="0"/>
       <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="offset_unit" v="MM"/>
       <prop k="use_custom_dash" v="0"/>
       <prop k="width_map_unit_scale" v="0,0,0,0,0,0"/>
      </layer>
     </symbol>
    </layer>
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="0,0,255,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="diagonal_x"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="2">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="165,191,221,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="114,133,132,255"/>
     <prop k="outline_style" v="no"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
    <layer pass="0" class="LinePatternFill" locked="1">
     <prop k="angle" v="45"/>
     <prop k="color" v="52,111,107,255"/>
     <prop k="distance" v="2"/>
     <prop k="distance_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="distance_unit" v="MM"/>
     <prop k="line_width" v="0.1"/>
     <prop k="line_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="line_width_unit" v="MM"/>
     <prop k="offset" v="1"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <symbol alpha="1" clip_to_extent="1" type="line" name="@2@1">
      <layer pass="0" class="SimpleLine" locked="0">
       <prop k="capstyle" v="square"/>
       <prop k="customdash" v="5;2"/>
       <prop k="customdash_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="customdash_unit" v="MM"/>
       <prop k="draw_inside_polygon" v="0"/>
       <prop k="joinstyle" v="bevel"/>
       <prop k="line_color" v="0,0,0,255"/>
       <prop k="line_style" v="no"/>
       <prop k="line_width" v="0.26"/>
       <prop k="line_width_unit" v="MM"/>
       <prop k="offset" v="0"/>
       <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="offset_unit" v="MM"/>
       <prop k="use_custom_dash" v="0"/>
       <prop k="width_map_unit_scale" v="0,0,0,0,0,0"/>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="3">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="165,191,221,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="114,133,132,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="0,0,255,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="b_diagonal"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="4">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="165,191,221,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="114,133,132,255"/>
     <prop k="outline_style" v="no"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="5">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="237,63,77,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
   </symbol>
  </symbols>
  <source-symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="0">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="144,79,91,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
   </symbol>
  </source-symbol>
  <colorramp type="randomcolors" name="[source]"/>
  <invertedcolorramp value="0"/>
  <rotation/>
  <sizescale scalemethod="diameter"/>
 </renderer-v2>
 <labeling type="simple"/>
 <customproperties>
  <property key="labeling" value="pal"/>
  <property key="labeling/addDirectionSymbol" value="false"/>
  <property key="labeling/angleOffset" value="0"/>
  <property key="labeling/blendMode" value="0"/>
  <property key="labeling/bufferBlendMode" value="0"/>
  <property key="labeling/bufferColorA" value="255"/>
  <property key="labeling/bufferColorB" value="255"/>
  <property key="labeling/bufferColorG" value="255"/>
  <property key="labeling/bufferColorR" value="255"/>
  <property key="labeling/bufferDraw" value="false"/>
  <property key="labeling/bufferJoinStyle" value="64"/>
  <property key="labeling/bufferNoFill" value="false"/>
  <property key="labeling/bufferSize" value="1"/>
  <property key="labeling/bufferSizeInMapUnits" value="false"/>
  <property key="labeling/bufferSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/bufferSizeMapUnitMinScale" value="0"/>
  <property key="labeling/bufferTransp" value="0"/>
  <property key="labeling/centroidInside" value="false"/>
  <property key="labeling/centroidWhole" value="false"/>
  <property key="labeling/decimals" value="3"/>
  <property key="labeling/displayAll" value="false"/>
  <property key="labeling/dist" value="0"/>
  <property key="labeling/distInMapUnits" value="false"/>
  <property key="labeling/distMapUnitMaxScale" value="0"/>
  <property key="labeling/distMapUnitMinScale" value="0"/>
  <property key="labeling/drawLabels" value="false"/>
  <property key="labeling/enabled" value="false"/>
  <property key="labeling/fieldName" value=""/>
  <property key="labeling/fitInPolygonOnly" value="false"/>
  <property key="labeling/fontCapitals" value="0"/>
  <property key="labeling/fontFamily" value="Ubuntu"/>
  <property key="labeling/fontItalic" value="false"/>
  <property key="labeling/fontLetterSpacing" value="0"/>
  <property key="labeling/fontLimitPixelSize" value="false"/>
  <property key="labeling/fontMaxPixelSize" value="10000"/>
  <property key="labeling/fontMinPixelSize" value="3"/>
  <property key="labeling/fontSize" value="13.5"/>
  <property key="labeling/fontSizeInMapUnits" value="false"/>
  <property key="labeling/fontSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/fontSizeMapUnitMinScale" value="0"/>
  <property key="labeling/fontStrikeout" value="false"/>
  <property key="labeling/fontUnderline" value="false"/>
  <property key="labeling/fontWeight" value="63"/>
  <property key="labeling/fontWordSpacing" value="0"/>
  <property key="labeling/formatNumbers" value="false"/>
  <property key="labeling/isExpression" value="true"/>
  <property key="labeling/labelOffsetInMapUnits" value="true"/>
  <property key="labeling/labelOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/labelOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/labelPerPart" value="false"/>
  <property key="labeling/leftDirectionSymbol" value="&lt;"/>
  <property key="labeling/limitNumLabels" value="false"/>
  <property key="labeling/maxCurvedCharAngleIn" value="20"/>
  <property key="labeling/maxCurvedCharAngleOut" value="-20"/>
  <property key="labeling/maxNumLabels" value="2000"/>
  <property key="labeling/mergeLines" value="false"/>
  <property key="labeling/minFeatureSize" value="0"/>
  <property key="labeling/multilineAlign" value="0"/>
  <property key="labeling/multilineHeight" value="1"/>
  <property key="labeling/namedStyle" value="Medium"/>
  <property key="labeling/obstacle" value="true"/>
  <property key="labeling/obstacleFactor" value="1"/>
  <property key="labeling/obstacleType" value="0"/>
  <property key="labeling/placeDirectionSymbol" value="0"/>
  <property key="labeling/placement" value="1"/>
  <property key="labeling/placementFlags" value="10"/>
  <property key="labeling/plussign" value="false"/>
  <property key="labeling/preserveRotation" value="true"/>
  <property key="labeling/previewBkgrdColor" value="#ffffff"/>
  <property key="labeling/priority" value="5"/>
  <property key="labeling/quadOffset" value="4"/>
  <property key="labeling/repeatDistance" value="0"/>
  <property key="labeling/repeatDistanceMapUnitMaxScale" value="0"/>
  <property key="labeling/repeatDistanceMapUnitMinScale" value="0"/>
  <property key="labeling/repeatDistanceUnit" value="1"/>
  <property key="labeling/reverseDirectionSymbol" value="false"/>
  <property key="labeling/rightDirectionSymbol" value=">"/>
  <property key="labeling/scaleMax" value="10000000"/>
  <property key="labeling/scaleMin" value="1"/>
  <property key="labeling/scaleVisibility" value="false"/>
  <property key="labeling/shadowBlendMode" value="6"/>
  <property key="labeling/shadowColorB" value="0"/>
  <property key="labeling/shadowColorG" value="0"/>
  <property key="labeling/shadowColorR" value="0"/>
  <property key="labeling/shadowDraw" value="false"/>
  <property key="labeling/shadowOffsetAngle" value="135"/>
  <property key="labeling/shadowOffsetDist" value="1"/>
  <property key="labeling/shadowOffsetGlobal" value="true"/>
  <property key="labeling/shadowOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/shadowOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/shadowOffsetUnits" value="1"/>
  <property key="labeling/shadowRadius" value="1.5"/>
  <property key="labeling/shadowRadiusAlphaOnly" value="false"/>
  <property key="labeling/shadowRadiusMapUnitMaxScale" value="0"/>
  <property key="labeling/shadowRadiusMapUnitMinScale" value="0"/>
  <property key="labeling/shadowRadiusUnits" value="1"/>
  <property key="labeling/shadowScale" value="100"/>
  <property key="labeling/shadowTransparency" value="30"/>
  <property key="labeling/shadowUnder" value="0"/>
  <property key="labeling/shapeBlendMode" value="0"/>
  <property key="labeling/shapeBorderColorA" value="255"/>
  <property key="labeling/shapeBorderColorB" value="128"/>
  <property key="labeling/shapeBorderColorG" value="128"/>
  <property key="labeling/shapeBorderColorR" value="128"/>
  <property key="labeling/shapeBorderWidth" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitMinScale" value="0"/>
  <property key="labeling/shapeBorderWidthUnits" value="1"/>
  <property key="labeling/shapeDraw" value="false"/>
  <property key="labeling/shapeFillColorA" value="255"/>
  <property key="labeling/shapeFillColorB" value="255"/>
  <property key="labeling/shapeFillColorG" value="255"/>
  <property key="labeling/shapeFillColorR" value="255"/>
  <property key="labeling/shapeJoinStyle" value="64"/>
  <property key="labeling/shapeOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/shapeOffsetUnits" value="1"/>
  <property key="labeling/shapeOffsetX" value="0"/>
  <property key="labeling/shapeOffsetY" value="0"/>
  <property key="labeling/shapeRadiiMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeRadiiMapUnitMinScale" value="0"/>
  <property key="labeling/shapeRadiiUnits" value="1"/>
  <property key="labeling/shapeRadiiX" value="0"/>
  <property key="labeling/shapeRadiiY" value="0"/>
  <property key="labeling/shapeRotation" value="0"/>
  <property key="labeling/shapeRotationType" value="0"/>
  <property key="labeling/shapeSVGFile" value=""/>
  <property key="labeling/shapeSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeSizeMapUnitMinScale" value="0"/>
  <property key="labeling/shapeSizeType" value="0"/>
  <property key="labeling/shapeSizeUnits" value="1"/>
  <property key="labeling/shapeSizeX" value="0"/>
  <property key="labeling/shapeSizeY" value="0"/>
  <property key="labeling/shapeTransparency" value="0"/>
  <property key="labeling/shapeType" value="0"/>
  <property key="labeling/textColorA" value="255"/>
  <property key="labeling/textColorB" value="0"/>
  <property key="labeling/textColorG" value="0"/>
  <property key="labeling/textColorR" value="0"/>
  <property key="labeling/textTransp" value="0"/>
  <property key="labeling/upsidedownLabels" value="0"/>
  <property key="labeling/wrapChar" value=""/>
  <property key="labeling/xOffset" value="0"/>
  <property key="labeling/yOffset" value="0"/>
  <property key="variableNames" value="_fields_"/>
  <property key="variableValues" value=""/>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerTransparency>0</layerTransparency>
 <displayfield>name</displayfield>
 <label>0</label>
 <labelattributes>
  <label fieldname="" text="Label"/>
  <family fieldname="" name="Ubuntu"/>
  <size fieldname="" units="pt" value="12"/>
  <bold fieldname="" on="0"/>
  <italic fieldname="" on="0"/>
  <underline fieldname="" on="0"/>
  <strikeout fieldname="" on="0"/>
  <color fieldname="" red="0" blue="0" green="0"/>
  <x fieldname=""/>
  <y fieldname=""/>
  <offset x="0" y="0" units="pt" yfieldname="" xfieldname=""/>
  <angle fieldname="" value="0" auto="0"/>
  <alignment fieldname="" value="center"/>
  <buffercolor fieldname="" red="255" blue="255" green="255"/>
  <buffersize fieldname="" units="pt" value="1"/>
  <bufferenabled fieldname="" on=""/>
  <multilineenabled fieldname="" on=""/>
  <selectedonly on=""/>
 </labelattributes>
 <SingleCategoryDiagramRenderer diagramType="Pie">
  <DiagramCategory penColor="#000000" labelPlacementMethod="XHeight" penWidth="0" diagramOrientation="Up" minimumSize="0" barWidth="5" penAlpha="255" maxScaleDenominator="1e+08" backgroundColor="#ffffff" transparency="0" width="15" scaleDependency="Area" backgroundAlpha="255" angleOffset="1440" scaleBasedVisibility="0" enabled="0" height="15" sizeType="MM" minScaleDenominator="0">
   <fontProperties description="Ubuntu,13.5,-1,5,50,0,0,0,0,0" style=""/>
  </DiagramCategory>
 </SingleCategoryDiagramRenderer>
 <DiagramLayerSettings yPosColumn="-1" linePlacementFlags="10" placement="0" dist="0" xPosColumn="-1" priority="0" obstacle="0" showAll="1"/>
 <editform></editform>
 <editforminit/>
 <featformsuppress>0</featformsuppress>
 <annotationform></annotationform>
 <editorlayout>generatedlayout</editorlayout>
 <excludeAttributesWMS/>
 <excludeAttributesWFS/>
 <attributeactions/>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
</qgis>
', '<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0" xmlns:xlink="http://www.w3.org/1999/xlink" units="mm" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:se="http://www.opengis.net/se">
 <NamedLayer>
  <se:Name>osm_waterareas</se:Name>
  <UserStyle>
   <se:Name>osm_waterareas</se:Name>
   <se:FeatureTypeStyle>
    <se:Rule>
     <se:Name>basin</se:Name>
     <se:Description>
      <se:Title>basin</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>basin</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#a5bfdd</se:SvgParameter>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#728584</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>horline</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#000000</se:SvgParameter>
           <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
         <se:Size>2</se:Size>
         <se:Rotation>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
           <ogc:Literal>45</ogc:Literal>
          </ogc:Filter>
         </se:Rotation>
         <se:Displacement>
          <se:DisplacementX>0.850904</se:DisplacementX>
          <se:DisplacementY>0.525322</se:DisplacementY>
         </se:Displacement>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>x</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#0000ff</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>reservoir</se:Name>
     <se:Description>
      <se:Title>reservoir</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>reservoir</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#a5bfdd</se:SvgParameter>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#728584</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>horline</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#000000</se:SvgParameter>
           <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
         <se:Size>2</se:Size>
         <se:Rotation>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
           <ogc:Literal>45</ogc:Literal>
          </ogc:Filter>
         </se:Rotation>
         <se:Displacement>
          <se:DisplacementX>0.850904</se:DisplacementX>
          <se:DisplacementY>0.525322</se:DisplacementY>
         </se:Displacement>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>x</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#0000ff</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>riverbank</se:Name>
     <se:Description>
      <se:Title>riverbank</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>riverbank</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#a5bfdd</se:SvgParameter>
      </se:Fill>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>horline</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#000000</se:SvgParameter>
           <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
         <se:Size>2</se:Size>
         <se:Rotation>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
           <ogc:Literal>45</ogc:Literal>
          </ogc:Filter>
         </se:Rotation>
         <se:Displacement>
          <se:DisplacementX>0.850904</se:DisplacementX>
          <se:DisplacementY>0.525322</se:DisplacementY>
         </se:Displacement>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
     </se:PolygonSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>swimming_pool</se:Name>
     <se:Description>
      <se:Title>swimming_pool</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>swimming_pool</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#a5bfdd</se:SvgParameter>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#728584</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>slash</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#0000ff</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>water</se:Name>
     <se:Description>
      <se:Title>water</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>water</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#a5bfdd</se:SvgParameter>
      </se:Fill>
     </se:PolygonSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name></se:Name>
     <se:Description>
      <se:Title>type is ''''</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal></ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#ed3f4d</se:SvgParameter>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
   </se:FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
', false, 'mar. déc. 22 10:19:53 2015', 'docker', NULL, '2015-12-22 09:19:53.591458');
INSERT INTO layer_styles VALUES (3, 'gis', 'public', 'osm_waterareas', 'geometry', 'osm_waterareas', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="2.14.3-Essen" minimumScale="-4.65661e-10" maximumScale="1e+08" simplifyDrawingHints="1" minLabelScale="0" maxLabelScale="1e+08" simplifyDrawingTol="1" simplifyMaxScale="1" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" scaleBasedLabelVisibilityFlag="0">
 <edittypes>
  <edittype widgetv2type="TextEdit" name="id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="osm_id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="name">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="type">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="area">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
 </edittypes>
 <renderer-v2 attr="type" forceraster="0" symbollevels="0" type="categorizedSymbol" enableorderby="0">
  <categories>
   <category render="true" symbol="0" value="basin" label="basin"/>
   <category render="true" symbol="1" value="reservoir" label="reservoir"/>
   <category render="true" symbol="2" value="riverbank" label="riverbank"/>
   <category render="true" symbol="3" value="swimming_pool" label="swimming_pool"/>
   <category render="true" symbol="4" value="water" label="water"/>
   <category render="true" symbol="5" value="" label=""/>
  </categories>
  <symbols>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="0">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="165,191,221,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="114,133,132,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
    <layer pass="0" class="LinePatternFill" locked="1">
     <prop k="angle" v="45"/>
     <prop k="color" v="52,111,107,255"/>
     <prop k="distance" v="2"/>
     <prop k="distance_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="distance_unit" v="MM"/>
     <prop k="line_width" v="0.1"/>
     <prop k="line_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="line_width_unit" v="MM"/>
     <prop k="offset" v="1"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <symbol alpha="1" clip_to_extent="1" type="line" name="@0@1">
      <layer pass="0" class="SimpleLine" locked="0">
       <prop k="capstyle" v="square"/>
       <prop k="customdash" v="5;2"/>
       <prop k="customdash_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="customdash_unit" v="MM"/>
       <prop k="draw_inside_polygon" v="0"/>
       <prop k="joinstyle" v="bevel"/>
       <prop k="line_color" v="0,0,0,255"/>
       <prop k="line_style" v="no"/>
       <prop k="line_width" v="0.26"/>
       <prop k="line_width_unit" v="MM"/>
       <prop k="offset" v="0"/>
       <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="offset_unit" v="MM"/>
       <prop k="use_custom_dash" v="0"/>
       <prop k="width_map_unit_scale" v="0,0,0,0,0,0"/>
      </layer>
     </symbol>
    </layer>
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="0,0,255,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="diagonal_x"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="1">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="165,191,221,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="114,133,132,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
    <layer pass="0" class="LinePatternFill" locked="1">
     <prop k="angle" v="45"/>
     <prop k="color" v="52,111,107,255"/>
     <prop k="distance" v="2"/>
     <prop k="distance_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="distance_unit" v="MM"/>
     <prop k="line_width" v="0.1"/>
     <prop k="line_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="line_width_unit" v="MM"/>
     <prop k="offset" v="1"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <symbol alpha="1" clip_to_extent="1" type="line" name="@1@1">
      <layer pass="0" class="SimpleLine" locked="0">
       <prop k="capstyle" v="square"/>
       <prop k="customdash" v="5;2"/>
       <prop k="customdash_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="customdash_unit" v="MM"/>
       <prop k="draw_inside_polygon" v="0"/>
       <prop k="joinstyle" v="bevel"/>
       <prop k="line_color" v="0,0,0,255"/>
       <prop k="line_style" v="no"/>
       <prop k="line_width" v="0.26"/>
       <prop k="line_width_unit" v="MM"/>
       <prop k="offset" v="0"/>
       <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="offset_unit" v="MM"/>
       <prop k="use_custom_dash" v="0"/>
       <prop k="width_map_unit_scale" v="0,0,0,0,0,0"/>
      </layer>
     </symbol>
    </layer>
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="0,0,255,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="diagonal_x"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="2">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="165,191,221,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="114,133,132,255"/>
     <prop k="outline_style" v="no"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
    <layer pass="0" class="LinePatternFill" locked="1">
     <prop k="angle" v="45"/>
     <prop k="color" v="52,111,107,255"/>
     <prop k="distance" v="2"/>
     <prop k="distance_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="distance_unit" v="MM"/>
     <prop k="line_width" v="0.1"/>
     <prop k="line_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="line_width_unit" v="MM"/>
     <prop k="offset" v="1"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <symbol alpha="1" clip_to_extent="1" type="line" name="@2@1">
      <layer pass="0" class="SimpleLine" locked="0">
       <prop k="capstyle" v="square"/>
       <prop k="customdash" v="5;2"/>
       <prop k="customdash_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="customdash_unit" v="MM"/>
       <prop k="draw_inside_polygon" v="0"/>
       <prop k="joinstyle" v="bevel"/>
       <prop k="line_color" v="0,0,0,255"/>
       <prop k="line_style" v="no"/>
       <prop k="line_width" v="0.26"/>
       <prop k="line_width_unit" v="MM"/>
       <prop k="offset" v="0"/>
       <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
       <prop k="offset_unit" v="MM"/>
       <prop k="use_custom_dash" v="0"/>
       <prop k="width_map_unit_scale" v="0,0,0,0,0,0"/>
      </layer>
     </symbol>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="3">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="165,191,221,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="114,133,132,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="0,0,255,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="b_diagonal"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="4">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="165,191,221,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="114,133,132,255"/>
     <prop k="outline_style" v="no"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="5">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="237,63,77,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
   </symbol>
  </symbols>
  <source-symbol>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="0">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="144,79,91,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
   </symbol>
  </source-symbol>
  <rotation/>
  <sizescale scalemethod="diameter"/>
 </renderer-v2>
 <labeling type="simple"/>
 <customproperties>
  <property key="labeling" value="pal"/>
  <property key="labeling/addDirectionSymbol" value="false"/>
  <property key="labeling/angleOffset" value="0"/>
  <property key="labeling/blendMode" value="0"/>
  <property key="labeling/bufferBlendMode" value="0"/>
  <property key="labeling/bufferColorA" value="255"/>
  <property key="labeling/bufferColorB" value="255"/>
  <property key="labeling/bufferColorG" value="255"/>
  <property key="labeling/bufferColorR" value="255"/>
  <property key="labeling/bufferDraw" value="false"/>
  <property key="labeling/bufferJoinStyle" value="64"/>
  <property key="labeling/bufferNoFill" value="false"/>
  <property key="labeling/bufferSize" value="1"/>
  <property key="labeling/bufferSizeInMapUnits" value="false"/>
  <property key="labeling/bufferSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/bufferSizeMapUnitMinScale" value="0"/>
  <property key="labeling/bufferSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/bufferTransp" value="0"/>
  <property key="labeling/centroidInside" value="false"/>
  <property key="labeling/centroidWhole" value="false"/>
  <property key="labeling/decimals" value="3"/>
  <property key="labeling/displayAll" value="false"/>
  <property key="labeling/dist" value="0"/>
  <property key="labeling/distInMapUnits" value="false"/>
  <property key="labeling/distMapUnitMaxScale" value="0"/>
  <property key="labeling/distMapUnitMinScale" value="0"/>
  <property key="labeling/distMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/drawLabels" value="false"/>
  <property key="labeling/enabled" value="false"/>
  <property key="labeling/fieldName" value=""/>
  <property key="labeling/fitInPolygonOnly" value="false"/>
  <property key="labeling/fontCapitals" value="0"/>
  <property key="labeling/fontFamily" value=".SF NS Text"/>
  <property key="labeling/fontItalic" value="false"/>
  <property key="labeling/fontLetterSpacing" value="0"/>
  <property key="labeling/fontLimitPixelSize" value="false"/>
  <property key="labeling/fontMaxPixelSize" value="10000"/>
  <property key="labeling/fontMinPixelSize" value="3"/>
  <property key="labeling/fontSize" value="13.5"/>
  <property key="labeling/fontSizeInMapUnits" value="false"/>
  <property key="labeling/fontSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/fontSizeMapUnitMinScale" value="0"/>
  <property key="labeling/fontSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/fontStrikeout" value="false"/>
  <property key="labeling/fontUnderline" value="false"/>
  <property key="labeling/fontWeight" value="63"/>
  <property key="labeling/fontWordSpacing" value="0"/>
  <property key="labeling/formatNumbers" value="false"/>
  <property key="labeling/isExpression" value="true"/>
  <property key="labeling/labelOffsetInMapUnits" value="true"/>
  <property key="labeling/labelOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/labelOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/labelOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/labelPerPart" value="false"/>
  <property key="labeling/leftDirectionSymbol" value="&lt;"/>
  <property key="labeling/limitNumLabels" value="false"/>
  <property key="labeling/maxCurvedCharAngleIn" value="20"/>
  <property key="labeling/maxCurvedCharAngleOut" value="-20"/>
  <property key="labeling/maxNumLabels" value="2000"/>
  <property key="labeling/mergeLines" value="false"/>
  <property key="labeling/minFeatureSize" value="0"/>
  <property key="labeling/multilineAlign" value="0"/>
  <property key="labeling/multilineHeight" value="1"/>
  <property key="labeling/namedStyle" value=""/>
  <property key="labeling/obstacle" value="true"/>
  <property key="labeling/obstacleFactor" value="1"/>
  <property key="labeling/obstacleType" value="0"/>
  <property key="labeling/offsetType" value="0"/>
  <property key="labeling/placeDirectionSymbol" value="0"/>
  <property key="labeling/placement" value="1"/>
  <property key="labeling/placementFlags" value="10"/>
  <property key="labeling/plussign" value="false"/>
  <property key="labeling/predefinedPositionOrder" value="TR,TL,BR,BL,R,L,TSR,BSR"/>
  <property key="labeling/preserveRotation" value="true"/>
  <property key="labeling/previewBkgrdColor" value="#ffffff"/>
  <property key="labeling/priority" value="5"/>
  <property key="labeling/quadOffset" value="4"/>
  <property key="labeling/repeatDistance" value="0"/>
  <property key="labeling/repeatDistanceMapUnitMaxScale" value="0"/>
  <property key="labeling/repeatDistanceMapUnitMinScale" value="0"/>
  <property key="labeling/repeatDistanceMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/repeatDistanceUnit" value="1"/>
  <property key="labeling/reverseDirectionSymbol" value="false"/>
  <property key="labeling/rightDirectionSymbol" value=">"/>
  <property key="labeling/scaleMax" value="10000000"/>
  <property key="labeling/scaleMin" value="1"/>
  <property key="labeling/scaleVisibility" value="false"/>
  <property key="labeling/shadowBlendMode" value="6"/>
  <property key="labeling/shadowColorB" value="0"/>
  <property key="labeling/shadowColorG" value="0"/>
  <property key="labeling/shadowColorR" value="0"/>
  <property key="labeling/shadowDraw" value="false"/>
  <property key="labeling/shadowOffsetAngle" value="135"/>
  <property key="labeling/shadowOffsetDist" value="1"/>
  <property key="labeling/shadowOffsetGlobal" value="true"/>
  <property key="labeling/shadowOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/shadowOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/shadowOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowOffsetUnits" value="1"/>
  <property key="labeling/shadowRadius" value="1.5"/>
  <property key="labeling/shadowRadiusAlphaOnly" value="false"/>
  <property key="labeling/shadowRadiusMapUnitMaxScale" value="0"/>
  <property key="labeling/shadowRadiusMapUnitMinScale" value="0"/>
  <property key="labeling/shadowRadiusMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowRadiusUnits" value="1"/>
  <property key="labeling/shadowScale" value="100"/>
  <property key="labeling/shadowTransparency" value="30"/>
  <property key="labeling/shadowUnder" value="0"/>
  <property key="labeling/shapeBlendMode" value="0"/>
  <property key="labeling/shapeBorderColorA" value="255"/>
  <property key="labeling/shapeBorderColorB" value="128"/>
  <property key="labeling/shapeBorderColorG" value="128"/>
  <property key="labeling/shapeBorderColorR" value="128"/>
  <property key="labeling/shapeBorderWidth" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitMinScale" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeBorderWidthUnits" value="1"/>
  <property key="labeling/shapeDraw" value="false"/>
  <property key="labeling/shapeFillColorA" value="255"/>
  <property key="labeling/shapeFillColorB" value="255"/>
  <property key="labeling/shapeFillColorG" value="255"/>
  <property key="labeling/shapeFillColorR" value="255"/>
  <property key="labeling/shapeJoinStyle" value="64"/>
  <property key="labeling/shapeOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/shapeOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeOffsetUnits" value="1"/>
  <property key="labeling/shapeOffsetX" value="0"/>
  <property key="labeling/shapeOffsetY" value="0"/>
  <property key="labeling/shapeRadiiMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeRadiiMapUnitMinScale" value="0"/>
  <property key="labeling/shapeRadiiMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeRadiiUnits" value="1"/>
  <property key="labeling/shapeRadiiX" value="0"/>
  <property key="labeling/shapeRadiiY" value="0"/>
  <property key="labeling/shapeRotation" value="0"/>
  <property key="labeling/shapeRotationType" value="0"/>
  <property key="labeling/shapeSVGFile" value=""/>
  <property key="labeling/shapeSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeSizeMapUnitMinScale" value="0"/>
  <property key="labeling/shapeSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeSizeType" value="0"/>
  <property key="labeling/shapeSizeUnits" value="1"/>
  <property key="labeling/shapeSizeX" value="0"/>
  <property key="labeling/shapeSizeY" value="0"/>
  <property key="labeling/shapeTransparency" value="0"/>
  <property key="labeling/shapeType" value="0"/>
  <property key="labeling/textColorA" value="255"/>
  <property key="labeling/textColorB" value="0"/>
  <property key="labeling/textColorG" value="0"/>
  <property key="labeling/textColorR" value="0"/>
  <property key="labeling/textTransp" value="0"/>
  <property key="labeling/upsidedownLabels" value="0"/>
  <property key="labeling/wrapChar" value=""/>
  <property key="labeling/xOffset" value="0"/>
  <property key="labeling/yOffset" value="0"/>
  <property key="labeling/zIndex" value="0"/>
  <property key="variableNames" value="_fields_"/>
  <property key="variableValues" value=""/>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerTransparency>0</layerTransparency>
 <displayfield>name</displayfield>
 <label>0</label>
 <labelattributes>
  <label fieldname="" text="Label"/>
  <family fieldname="" name="Ubuntu"/>
  <size fieldname="" units="pt" value="12"/>
  <bold fieldname="" on="0"/>
  <italic fieldname="" on="0"/>
  <underline fieldname="" on="0"/>
  <strikeout fieldname="" on="0"/>
  <color fieldname="" red="0" blue="0" green="0"/>
  <x fieldname=""/>
  <y fieldname=""/>
  <offset x="0" y="0" units="pt" yfieldname="" xfieldname=""/>
  <angle fieldname="" value="0" auto="0"/>
  <alignment fieldname="" value="center"/>
  <buffercolor fieldname="" red="255" blue="255" green="255"/>
  <buffersize fieldname="" units="pt" value="1"/>
  <bufferenabled fieldname="" on=""/>
  <multilineenabled fieldname="" on=""/>
  <selectedonly on=""/>
 </labelattributes>
 <SingleCategoryDiagramRenderer diagramType="Pie">
  <DiagramCategory penColor="#000000" labelPlacementMethod="XHeight" penWidth="0" diagramOrientation="Up" minimumSize="0" barWidth="5" penAlpha="255" maxScaleDenominator="1e+08" backgroundColor="#ffffff" transparency="0" width="15" scaleDependency="Area" backgroundAlpha="255" angleOffset="1440" scaleBasedVisibility="0" enabled="0" height="15" sizeType="MM" minScaleDenominator="-4.65661e-10">
   <fontProperties description="Ubuntu,13.5,-1,5,50,0,0,0,0,0" style=""/>
   <attribute field="" color="#000000" label=""/>
  </DiagramCategory>
 </SingleCategoryDiagramRenderer>
 <DiagramLayerSettings yPosColumn="-1" linePlacementFlags="10" placement="0" dist="0" xPosColumn="-1" priority="0" obstacle="0" zIndex="0" showAll="1"/>
 <annotationform>.</annotationform>
 <excludeAttributesWMS/>
 <excludeAttributesWFS/>
 <attributeactions/>
 <editform>.</editform>
 <editforminit/>
 <editforminitcodesource>0</editforminitcodesource>
 <editforminitfilepath>.</editforminitfilepath>
 <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from PyQt4.QtGui import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
 <featformsuppress>0</featformsuppress>
 <editorlayout>generatedlayout</editorlayout>
 <widgets/>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
 <layerGeometryType>2</layerGeometryType>
</qgis>
', '<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0" xmlns:xlink="http://www.w3.org/1999/xlink" units="mm" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:se="http://www.opengis.net/se">
 <NamedLayer>
  <se:Name>osm_waterareas</se:Name>
  <UserStyle>
   <se:Name>osm_waterareas</se:Name>
   <se:FeatureTypeStyle>
    <se:Rule>
     <se:Name>basin</se:Name>
     <se:Description>
      <se:Title>basin</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>basin</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#a5bfdd</se:SvgParameter>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#728584</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>horline</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#000000</se:SvgParameter>
           <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
         <se:Size>2</se:Size>
         <se:Rotation>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
           <ogc:Literal>45</ogc:Literal>
          </ogc:Filter>
         </se:Rotation>
         <se:Displacement>
          <se:DisplacementX>0.850904</se:DisplacementX>
          <se:DisplacementY>0.525322</se:DisplacementY>
         </se:Displacement>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>x</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#0000ff</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>reservoir</se:Name>
     <se:Description>
      <se:Title>reservoir</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>reservoir</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#a5bfdd</se:SvgParameter>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#728584</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>horline</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#000000</se:SvgParameter>
           <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
         <se:Size>2</se:Size>
         <se:Rotation>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
           <ogc:Literal>45</ogc:Literal>
          </ogc:Filter>
         </se:Rotation>
         <se:Displacement>
          <se:DisplacementX>0.850904</se:DisplacementX>
          <se:DisplacementY>0.525322</se:DisplacementY>
         </se:Displacement>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>x</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#0000ff</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>riverbank</se:Name>
     <se:Description>
      <se:Title>riverbank</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>riverbank</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#a5bfdd</se:SvgParameter>
      </se:Fill>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>horline</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#000000</se:SvgParameter>
           <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
         <se:Size>2</se:Size>
         <se:Rotation>
          <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
           <ogc:Literal>45</ogc:Literal>
          </ogc:Filter>
         </se:Rotation>
         <se:Displacement>
          <se:DisplacementX>0.850904</se:DisplacementX>
          <se:DisplacementY>0.525322</se:DisplacementY>
         </se:Displacement>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
     </se:PolygonSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>swimming_pool</se:Name>
     <se:Description>
      <se:Title>swimming_pool</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>swimming_pool</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#a5bfdd</se:SvgParameter>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#728584</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:GraphicFill>
        <se:Graphic>
         <se:Mark>
          <se:WellKnownName>slash</se:WellKnownName>
          <se:Stroke>
           <se:SvgParameter name="stroke">#0000ff</se:SvgParameter>
          </se:Stroke>
         </se:Mark>
        </se:Graphic>
       </se:GraphicFill>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>water</se:Name>
     <se:Description>
      <se:Title>water</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>water</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#a5bfdd</se:SvgParameter>
      </se:Fill>
     </se:PolygonSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name></se:Name>
     <se:Description>
      <se:Title>type is ''''</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal></ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#ed3f4d</se:SvgParameter>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
   </se:FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
', true, 'Wed Jul 20 01:43:14 2016', 'docker', NULL, '2016-07-19 18:43:14.861512');
INSERT INTO layer_styles VALUES (4, 'gis', 'public', 'osm_waterways', 'geometry', 'osm_waterways', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="2.14.3-Essen" minimumScale="1" maximumScale="3.25069e+06" simplifyDrawingHints="1" minLabelScale="0" maxLabelScale="1e+08" simplifyDrawingTol="1" simplifyMaxScale="1" hasScaleBasedVisibilityFlag="1" simplifyLocal="1" scaleBasedLabelVisibilityFlag="0">
 <edittypes>
  <edittype widgetv2type="TextEdit" name="id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="osm_id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="name">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="type">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
 </edittypes>
 <renderer-v2 forceraster="0" symbollevels="0" type="singleSymbol" enableorderby="0">
  <symbols>
   <symbol alpha="1" clip_to_extent="1" type="line" name="0">
    <layer pass="0" class="SimpleLine" locked="0">
     <prop k="capstyle" v="round"/>
     <prop k="customdash" v="5;2"/>
     <prop k="customdash_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="customdash_unit" v="MM"/>
     <prop k="draw_inside_polygon" v="0"/>
     <prop k="joinstyle" v="round"/>
     <prop k="line_color" v="165,191,221,255"/>
     <prop k="line_style" v="solid"/>
     <prop k="line_width" v="1"/>
     <prop k="line_width_unit" v="MM"/>
     <prop k="offset" v="0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="use_custom_dash" v="0"/>
     <prop k="width_map_unit_scale" v="0,0,0,0,0,0"/>
    </layer>
   </symbol>
  </symbols>
  <rotation/>
  <sizescale scalemethod="diameter"/>
 </renderer-v2>
 <labeling type="simple"/>
 <customproperties>
  <property key="embeddedWidgets/count" value="0"/>
  <property key="labeling" value="pal"/>
  <property key="labeling/addDirectionSymbol" value="false"/>
  <property key="labeling/angleOffset" value="0"/>
  <property key="labeling/blendMode" value="0"/>
  <property key="labeling/bufferBlendMode" value="0"/>
  <property key="labeling/bufferColorA" value="255"/>
  <property key="labeling/bufferColorB" value="255"/>
  <property key="labeling/bufferColorG" value="255"/>
  <property key="labeling/bufferColorR" value="255"/>
  <property key="labeling/bufferDraw" value="false"/>
  <property key="labeling/bufferJoinStyle" value="64"/>
  <property key="labeling/bufferNoFill" value="false"/>
  <property key="labeling/bufferSize" value="1"/>
  <property key="labeling/bufferSizeInMapUnits" value="false"/>
  <property key="labeling/bufferSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/bufferTransp" value="0"/>
  <property key="labeling/centroidInside" value="false"/>
  <property key="labeling/centroidWhole" value="false"/>
  <property key="labeling/decimals" value="3"/>
  <property key="labeling/displayAll" value="false"/>
  <property key="labeling/dist" value="0"/>
  <property key="labeling/distInMapUnits" value="false"/>
  <property key="labeling/distMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/drawLabels" value="false"/>
  <property key="labeling/enabled" value="false"/>
  <property key="labeling/fieldName" value=""/>
  <property key="labeling/fitInPolygonOnly" value="false"/>
  <property key="labeling/fontCapitals" value="0"/>
  <property key="labeling/fontFamily" value=".SF NS Text"/>
  <property key="labeling/fontItalic" value="false"/>
  <property key="labeling/fontLetterSpacing" value="0"/>
  <property key="labeling/fontLimitPixelSize" value="false"/>
  <property key="labeling/fontMaxPixelSize" value="10000"/>
  <property key="labeling/fontMinPixelSize" value="3"/>
  <property key="labeling/fontSize" value="13"/>
  <property key="labeling/fontSizeInMapUnits" value="false"/>
  <property key="labeling/fontSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/fontStrikeout" value="false"/>
  <property key="labeling/fontUnderline" value="false"/>
  <property key="labeling/fontWeight" value="50"/>
  <property key="labeling/fontWordSpacing" value="0"/>
  <property key="labeling/formatNumbers" value="false"/>
  <property key="labeling/isExpression" value="true"/>
  <property key="labeling/labelOffsetInMapUnits" value="true"/>
  <property key="labeling/labelOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/labelPerPart" value="false"/>
  <property key="labeling/leftDirectionSymbol" value="&lt;"/>
  <property key="labeling/limitNumLabels" value="false"/>
  <property key="labeling/maxCurvedCharAngleIn" value="20"/>
  <property key="labeling/maxCurvedCharAngleOut" value="-20"/>
  <property key="labeling/maxNumLabels" value="2000"/>
  <property key="labeling/mergeLines" value="false"/>
  <property key="labeling/minFeatureSize" value="0"/>
  <property key="labeling/multilineAlign" value="0"/>
  <property key="labeling/multilineHeight" value="1"/>
  <property key="labeling/namedStyle" value=""/>
  <property key="labeling/obstacle" value="true"/>
  <property key="labeling/obstacleFactor" value="1"/>
  <property key="labeling/obstacleType" value="0"/>
  <property key="labeling/offsetType" value="0"/>
  <property key="labeling/placeDirectionSymbol" value="0"/>
  <property key="labeling/placement" value="2"/>
  <property key="labeling/placementFlags" value="10"/>
  <property key="labeling/plussign" value="false"/>
  <property key="labeling/predefinedPositionOrder" value="TR,TL,BR,BL,R,L,TSR,BSR"/>
  <property key="labeling/preserveRotation" value="true"/>
  <property key="labeling/previewBkgrdColor" value="#ffffff"/>
  <property key="labeling/priority" value="5"/>
  <property key="labeling/quadOffset" value="4"/>
  <property key="labeling/repeatDistance" value="0"/>
  <property key="labeling/repeatDistanceMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/repeatDistanceUnit" value="1"/>
  <property key="labeling/reverseDirectionSymbol" value="false"/>
  <property key="labeling/rightDirectionSymbol" value=">"/>
  <property key="labeling/scaleMax" value="10000000"/>
  <property key="labeling/scaleMin" value="1"/>
  <property key="labeling/scaleVisibility" value="false"/>
  <property key="labeling/shadowBlendMode" value="6"/>
  <property key="labeling/shadowColorB" value="0"/>
  <property key="labeling/shadowColorG" value="0"/>
  <property key="labeling/shadowColorR" value="0"/>
  <property key="labeling/shadowDraw" value="false"/>
  <property key="labeling/shadowOffsetAngle" value="135"/>
  <property key="labeling/shadowOffsetDist" value="1"/>
  <property key="labeling/shadowOffsetGlobal" value="true"/>
  <property key="labeling/shadowOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowOffsetUnits" value="1"/>
  <property key="labeling/shadowRadius" value="1.5"/>
  <property key="labeling/shadowRadiusAlphaOnly" value="false"/>
  <property key="labeling/shadowRadiusMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowRadiusUnits" value="1"/>
  <property key="labeling/shadowScale" value="100"/>
  <property key="labeling/shadowTransparency" value="30"/>
  <property key="labeling/shadowUnder" value="0"/>
  <property key="labeling/shapeBlendMode" value="0"/>
  <property key="labeling/shapeBorderColorA" value="255"/>
  <property key="labeling/shapeBorderColorB" value="128"/>
  <property key="labeling/shapeBorderColorG" value="128"/>
  <property key="labeling/shapeBorderColorR" value="128"/>
  <property key="labeling/shapeBorderWidth" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeBorderWidthUnits" value="1"/>
  <property key="labeling/shapeDraw" value="false"/>
  <property key="labeling/shapeFillColorA" value="255"/>
  <property key="labeling/shapeFillColorB" value="255"/>
  <property key="labeling/shapeFillColorG" value="255"/>
  <property key="labeling/shapeFillColorR" value="255"/>
  <property key="labeling/shapeJoinStyle" value="64"/>
  <property key="labeling/shapeOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeOffsetUnits" value="1"/>
  <property key="labeling/shapeOffsetX" value="0"/>
  <property key="labeling/shapeOffsetY" value="0"/>
  <property key="labeling/shapeRadiiMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeRadiiUnits" value="1"/>
  <property key="labeling/shapeRadiiX" value="0"/>
  <property key="labeling/shapeRadiiY" value="0"/>
  <property key="labeling/shapeRotation" value="0"/>
  <property key="labeling/shapeRotationType" value="0"/>
  <property key="labeling/shapeSVGFile" value=""/>
  <property key="labeling/shapeSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeSizeType" value="0"/>
  <property key="labeling/shapeSizeUnits" value="1"/>
  <property key="labeling/shapeSizeX" value="0"/>
  <property key="labeling/shapeSizeY" value="0"/>
  <property key="labeling/shapeTransparency" value="0"/>
  <property key="labeling/shapeType" value="0"/>
  <property key="labeling/textColorA" value="255"/>
  <property key="labeling/textColorB" value="0"/>
  <property key="labeling/textColorG" value="0"/>
  <property key="labeling/textColorR" value="0"/>
  <property key="labeling/textTransp" value="0"/>
  <property key="labeling/upsidedownLabels" value="0"/>
  <property key="labeling/wrapChar" value=""/>
  <property key="labeling/xOffset" value="0"/>
  <property key="labeling/yOffset" value="0"/>
  <property key="labeling/zIndex" value="0"/>
  <property key="variableNames" value="_fields_"/>
  <property key="variableValues" value=""/>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerTransparency>0</layerTransparency>
 <displayfield>name</displayfield>
 <label>0</label>
 <labelattributes>
  <label fieldname="" text="Label"/>
  <family fieldname="" name=".SF NS Text"/>
  <size fieldname="" units="pt" value="12"/>
  <bold fieldname="" on="0"/>
  <italic fieldname="" on="0"/>
  <underline fieldname="" on="0"/>
  <strikeout fieldname="" on="0"/>
  <color fieldname="" red="0" blue="0" green="0"/>
  <x fieldname=""/>
  <y fieldname=""/>
  <offset x="0" y="0" units="pt" yfieldname="" xfieldname=""/>
  <angle fieldname="" value="0" auto="0"/>
  <alignment fieldname="" value="center"/>
  <buffercolor fieldname="" red="255" blue="255" green="255"/>
  <buffersize fieldname="" units="pt" value="1"/>
  <bufferenabled fieldname="" on=""/>
  <multilineenabled fieldname="" on=""/>
  <selectedonly on=""/>
 </labelattributes>
 <LinearlyInterpolatedDiagramRenderer upperValue="0" lowerHeight="0" upperHeight="50" lowerValue="0" diagramType="Histogram" upperWidth="50" classificationAttributeExpression="" lowerWidth="0">
  <DiagramCategory penColor="#000000" labelPlacementMethod="XHeight" penWidth="0" diagramOrientation="Up" minimumSize="0" barWidth="5" penAlpha="255" maxScaleDenominator="1e+08" backgroundColor="#ffffff" transparency="0" width="15" scaleDependency="Area" backgroundAlpha="255" angleOffset="1440" scaleBasedVisibility="0" enabled="0" height="15" sizeType="MM" minScaleDenominator="100000">
   <fontProperties description=".SF NS Text,13,-1,5,50,0,0,0,0,0" style=""/>
   <attribute field="" color="#000000" label=""/>
  </DiagramCategory>
 </LinearlyInterpolatedDiagramRenderer>
 <DiagramLayerSettings yPosColumn="-1" linePlacementFlags="10" placement="2" dist="0" xPosColumn="-1" priority="0" obstacle="0" zIndex="0" showAll="1"/>
 <annotationform>.</annotationform>
 <excludeAttributesWMS/>
 <excludeAttributesWFS/>
 <attributeactions/>
 <editform>.</editform>
 <editforminit/>
 <editforminitcodesource>0</editforminitcodesource>
 <editforminitfilepath>.</editforminitfilepath>
 <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
 <featformsuppress>0</featformsuppress>
 <editorlayout>generatedlayout</editorlayout>
 <widgets/>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
 <layerGeometryType>1</layerGeometryType>
</qgis>
', '<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0" xmlns:xlink="http://www.w3.org/1999/xlink" units="mm" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:se="http://www.opengis.net/se">
 <NamedLayer>
  <se:Name>osm_waterways</se:Name>
  <UserStyle>
   <se:Name>osm_waterways</se:Name>
   <se:FeatureTypeStyle>
    <se:Rule>
     <se:Name>Single symbol</se:Name>
     <se:LineSymbolizer>
      <se:Stroke>
       <se:SvgParameter name="stroke">#a5bfdd</se:SvgParameter>
       <se:SvgParameter name="stroke-width">1</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">round</se:SvgParameter>
       <se:SvgParameter name="stroke-linecap">round</se:SvgParameter>
      </se:Stroke>
     </se:LineSymbolizer>
    </se:Rule>
   </se:FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
', true, 'Wed Jul 20 01:43:27 2016', 'docker', NULL, '2016-07-19 18:43:27.766761');
INSERT INTO layer_styles VALUES (5, 'gis', 'public', 'osm_roads', 'geometry', 'osm_roads', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="2.14.3-Essen" minimumScale="1" maximumScale="100000" simplifyDrawingHints="1" minLabelScale="0" maxLabelScale="1e+08" simplifyDrawingTol="1" simplifyMaxScale="1" hasScaleBasedVisibilityFlag="1" simplifyLocal="1" scaleBasedLabelVisibilityFlag="0">
 <edittypes>
  <edittype widgetv2type="TextEdit" name="id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="osm_id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="type">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="name">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="tunnel">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="bridge">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="oneway">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="ref">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="z_order">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="access">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="service">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="class">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
 </edittypes>
 <renderer-v2 forceraster="0" symbollevels="0" type="singleSymbol" enableorderby="0">
  <symbols>
   <symbol alpha="1" clip_to_extent="1" type="line" name="0">
    <layer pass="0" class="SimpleLine" locked="0">
     <prop k="capstyle" v="square"/>
     <prop k="customdash" v="5;2"/>
     <prop k="customdash_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="customdash_unit" v="MM"/>
     <prop k="draw_inside_polygon" v="0"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="line_color" v="225,93,93,255"/>
     <prop k="line_style" v="solid"/>
     <prop k="line_width" v="0.26"/>
     <prop k="line_width_unit" v="MM"/>
     <prop k="offset" v="0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="use_custom_dash" v="0"/>
     <prop k="width_map_unit_scale" v="0,0,0,0,0,0"/>
    </layer>
   </symbol>
  </symbols>
  <rotation/>
  <sizescale scalemethod="diameter"/>
 </renderer-v2>
 <labeling type="simple"/>
 <customproperties>
  <property key="labeling" value="pal"/>
  <property key="labeling/addDirectionSymbol" value="false"/>
  <property key="labeling/angleOffset" value="0"/>
  <property key="labeling/blendMode" value="0"/>
  <property key="labeling/bufferBlendMode" value="0"/>
  <property key="labeling/bufferColorA" value="255"/>
  <property key="labeling/bufferColorB" value="255"/>
  <property key="labeling/bufferColorG" value="255"/>
  <property key="labeling/bufferColorR" value="255"/>
  <property key="labeling/bufferDraw" value="false"/>
  <property key="labeling/bufferJoinStyle" value="64"/>
  <property key="labeling/bufferNoFill" value="false"/>
  <property key="labeling/bufferSize" value="1"/>
  <property key="labeling/bufferSizeInMapUnits" value="false"/>
  <property key="labeling/bufferSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/bufferTransp" value="0"/>
  <property key="labeling/centroidInside" value="false"/>
  <property key="labeling/centroidWhole" value="false"/>
  <property key="labeling/decimals" value="3"/>
  <property key="labeling/displayAll" value="false"/>
  <property key="labeling/dist" value="0"/>
  <property key="labeling/distInMapUnits" value="false"/>
  <property key="labeling/distMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/drawLabels" value="false"/>
  <property key="labeling/enabled" value="false"/>
  <property key="labeling/fieldName" value=""/>
  <property key="labeling/fitInPolygonOnly" value="false"/>
  <property key="labeling/fontCapitals" value="0"/>
  <property key="labeling/fontFamily" value=".SF NS Text"/>
  <property key="labeling/fontItalic" value="false"/>
  <property key="labeling/fontLetterSpacing" value="0"/>
  <property key="labeling/fontLimitPixelSize" value="false"/>
  <property key="labeling/fontMaxPixelSize" value="10000"/>
  <property key="labeling/fontMinPixelSize" value="3"/>
  <property key="labeling/fontSize" value="13"/>
  <property key="labeling/fontSizeInMapUnits" value="false"/>
  <property key="labeling/fontSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/fontStrikeout" value="false"/>
  <property key="labeling/fontUnderline" value="false"/>
  <property key="labeling/fontWeight" value="50"/>
  <property key="labeling/fontWordSpacing" value="0"/>
  <property key="labeling/formatNumbers" value="false"/>
  <property key="labeling/isExpression" value="true"/>
  <property key="labeling/labelOffsetInMapUnits" value="true"/>
  <property key="labeling/labelOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/labelPerPart" value="false"/>
  <property key="labeling/leftDirectionSymbol" value="&lt;"/>
  <property key="labeling/limitNumLabels" value="false"/>
  <property key="labeling/maxCurvedCharAngleIn" value="20"/>
  <property key="labeling/maxCurvedCharAngleOut" value="-20"/>
  <property key="labeling/maxNumLabels" value="2000"/>
  <property key="labeling/mergeLines" value="false"/>
  <property key="labeling/minFeatureSize" value="0"/>
  <property key="labeling/multilineAlign" value="0"/>
  <property key="labeling/multilineHeight" value="1"/>
  <property key="labeling/namedStyle" value=""/>
  <property key="labeling/obstacle" value="true"/>
  <property key="labeling/obstacleFactor" value="1"/>
  <property key="labeling/obstacleType" value="0"/>
  <property key="labeling/offsetType" value="0"/>
  <property key="labeling/placeDirectionSymbol" value="0"/>
  <property key="labeling/placement" value="2"/>
  <property key="labeling/placementFlags" value="10"/>
  <property key="labeling/plussign" value="false"/>
  <property key="labeling/predefinedPositionOrder" value="TR,TL,BR,BL,R,L,TSR,BSR"/>
  <property key="labeling/preserveRotation" value="true"/>
  <property key="labeling/previewBkgrdColor" value="#ffffff"/>
  <property key="labeling/priority" value="5"/>
  <property key="labeling/quadOffset" value="4"/>
  <property key="labeling/repeatDistance" value="0"/>
  <property key="labeling/repeatDistanceMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/repeatDistanceUnit" value="1"/>
  <property key="labeling/reverseDirectionSymbol" value="false"/>
  <property key="labeling/rightDirectionSymbol" value=">"/>
  <property key="labeling/scaleMax" value="10000000"/>
  <property key="labeling/scaleMin" value="1"/>
  <property key="labeling/scaleVisibility" value="false"/>
  <property key="labeling/shadowBlendMode" value="6"/>
  <property key="labeling/shadowColorB" value="0"/>
  <property key="labeling/shadowColorG" value="0"/>
  <property key="labeling/shadowColorR" value="0"/>
  <property key="labeling/shadowDraw" value="false"/>
  <property key="labeling/shadowOffsetAngle" value="135"/>
  <property key="labeling/shadowOffsetDist" value="1"/>
  <property key="labeling/shadowOffsetGlobal" value="true"/>
  <property key="labeling/shadowOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowOffsetUnits" value="1"/>
  <property key="labeling/shadowRadius" value="1.5"/>
  <property key="labeling/shadowRadiusAlphaOnly" value="false"/>
  <property key="labeling/shadowRadiusMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowRadiusUnits" value="1"/>
  <property key="labeling/shadowScale" value="100"/>
  <property key="labeling/shadowTransparency" value="30"/>
  <property key="labeling/shadowUnder" value="0"/>
  <property key="labeling/shapeBlendMode" value="0"/>
  <property key="labeling/shapeBorderColorA" value="255"/>
  <property key="labeling/shapeBorderColorB" value="128"/>
  <property key="labeling/shapeBorderColorG" value="128"/>
  <property key="labeling/shapeBorderColorR" value="128"/>
  <property key="labeling/shapeBorderWidth" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeBorderWidthUnits" value="1"/>
  <property key="labeling/shapeDraw" value="false"/>
  <property key="labeling/shapeFillColorA" value="255"/>
  <property key="labeling/shapeFillColorB" value="255"/>
  <property key="labeling/shapeFillColorG" value="255"/>
  <property key="labeling/shapeFillColorR" value="255"/>
  <property key="labeling/shapeJoinStyle" value="64"/>
  <property key="labeling/shapeOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeOffsetUnits" value="1"/>
  <property key="labeling/shapeOffsetX" value="0"/>
  <property key="labeling/shapeOffsetY" value="0"/>
  <property key="labeling/shapeRadiiMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeRadiiUnits" value="1"/>
  <property key="labeling/shapeRadiiX" value="0"/>
  <property key="labeling/shapeRadiiY" value="0"/>
  <property key="labeling/shapeRotation" value="0"/>
  <property key="labeling/shapeRotationType" value="0"/>
  <property key="labeling/shapeSVGFile" value=""/>
  <property key="labeling/shapeSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeSizeType" value="0"/>
  <property key="labeling/shapeSizeUnits" value="1"/>
  <property key="labeling/shapeSizeX" value="0"/>
  <property key="labeling/shapeSizeY" value="0"/>
  <property key="labeling/shapeTransparency" value="0"/>
  <property key="labeling/shapeType" value="0"/>
  <property key="labeling/textColorA" value="255"/>
  <property key="labeling/textColorB" value="0"/>
  <property key="labeling/textColorG" value="0"/>
  <property key="labeling/textColorR" value="0"/>
  <property key="labeling/textTransp" value="0"/>
  <property key="labeling/upsidedownLabels" value="0"/>
  <property key="labeling/wrapChar" value=""/>
  <property key="labeling/xOffset" value="0"/>
  <property key="labeling/yOffset" value="0"/>
  <property key="labeling/zIndex" value="0"/>
  <property key="variableNames" value="_fields_"/>
  <property key="variableValues" value=""/>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerTransparency>0</layerTransparency>
 <displayfield>name</displayfield>
 <label>0</label>
 <labelattributes>
  <label fieldname="" text="Label"/>
  <family fieldname="" name=".SF NS Text"/>
  <size fieldname="" units="pt" value="12"/>
  <bold fieldname="" on="0"/>
  <italic fieldname="" on="0"/>
  <underline fieldname="" on="0"/>
  <strikeout fieldname="" on="0"/>
  <color fieldname="" red="0" blue="0" green="0"/>
  <x fieldname=""/>
  <y fieldname=""/>
  <offset x="0" y="0" units="pt" yfieldname="" xfieldname=""/>
  <angle fieldname="" value="0" auto="0"/>
  <alignment fieldname="" value="center"/>
  <buffercolor fieldname="" red="255" blue="255" green="255"/>
  <buffersize fieldname="" units="pt" value="1"/>
  <bufferenabled fieldname="" on=""/>
  <multilineenabled fieldname="" on=""/>
  <selectedonly on=""/>
 </labelattributes>
 <SingleCategoryDiagramRenderer diagramType="Pie">
  <DiagramCategory penColor="#000000" labelPlacementMethod="XHeight" penWidth="0" diagramOrientation="Up" minimumSize="0" barWidth="5" penAlpha="255" maxScaleDenominator="1e+08" backgroundColor="#ffffff" transparency="0" width="15" scaleDependency="Area" backgroundAlpha="255" angleOffset="1440" scaleBasedVisibility="0" enabled="0" height="15" sizeType="MM" minScaleDenominator="1">
   <fontProperties description=".SF NS Text,13,-1,5,50,0,0,0,0,0" style=""/>
   <attribute field="" color="#000000" label=""/>
  </DiagramCategory>
 </SingleCategoryDiagramRenderer>
 <DiagramLayerSettings yPosColumn="-1" linePlacementFlags="10" placement="2" dist="0" xPosColumn="-1" priority="0" obstacle="0" zIndex="0" showAll="1"/>
 <annotationform>.</annotationform>
 <excludeAttributesWMS/>
 <excludeAttributesWFS/>
 <attributeactions/>
 <editform>.</editform>
 <editforminit/>
 <editforminitcodesource>0</editforminitcodesource>
 <editforminitfilepath>.</editforminitfilepath>
 <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from PyQt4.QtGui import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
 <featformsuppress>0</featformsuppress>
 <editorlayout>generatedlayout</editorlayout>
 <widgets/>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
 <layerGeometryType>1</layerGeometryType>
</qgis>
', '<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0" xmlns:xlink="http://www.w3.org/1999/xlink" units="mm" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:se="http://www.opengis.net/se">
 <NamedLayer>
  <se:Name>osm_roads</se:Name>
  <UserStyle>
   <se:Name>osm_roads</se:Name>
   <se:FeatureTypeStyle>
    <se:Rule>
     <se:Name>Single symbol</se:Name>
     <se:LineSymbolizer>
      <se:Stroke>
       <se:SvgParameter name="stroke">#e15d5d</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
       <se:SvgParameter name="stroke-linecap">square</se:SvgParameter>
      </se:Stroke>
     </se:LineSymbolizer>
    </se:Rule>
   </se:FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
', true, 'Wed Jul 20 01:43:38 2016', 'docker', NULL, '2016-07-19 18:43:38.405347');
INSERT INTO layer_styles VALUES (6, 'gis', 'public', 'osm_buildings', 'geometry', 'osm_buildings', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="2.14.3-Essen" minimumScale="1" maximumScale="3.25069e+06" simplifyDrawingHints="1" minLabelScale="0" maxLabelScale="1e+08" simplifyDrawingTol="1" simplifyMaxScale="1" hasScaleBasedVisibilityFlag="1" simplifyLocal="1" scaleBasedLabelVisibilityFlag="0">
 <edittypes>
  <edittype widgetv2type="TextEdit" name="id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="osm_id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="name">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="type">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
 </edittypes>
 <renderer-v2 forceraster="0" symbollevels="0" type="singleSymbol" enableorderby="0">
  <symbols>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="0">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="180,180,180,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="solid"/>
    </layer>
   </symbol>
  </symbols>
  <rotation/>
  <sizescale scalemethod="diameter"/>
 </renderer-v2>
 <labeling type="simple"/>
 <customproperties>
  <property key="embeddedWidgets/count" value="0"/>
  <property key="labeling" value="pal"/>
  <property key="labeling/addDirectionSymbol" value="false"/>
  <property key="labeling/angleOffset" value="0"/>
  <property key="labeling/blendMode" value="0"/>
  <property key="labeling/bufferBlendMode" value="0"/>
  <property key="labeling/bufferColorA" value="255"/>
  <property key="labeling/bufferColorB" value="255"/>
  <property key="labeling/bufferColorG" value="255"/>
  <property key="labeling/bufferColorR" value="255"/>
  <property key="labeling/bufferDraw" value="false"/>
  <property key="labeling/bufferJoinStyle" value="64"/>
  <property key="labeling/bufferNoFill" value="false"/>
  <property key="labeling/bufferSize" value="1"/>
  <property key="labeling/bufferSizeInMapUnits" value="false"/>
  <property key="labeling/bufferSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/bufferTransp" value="0"/>
  <property key="labeling/centroidInside" value="false"/>
  <property key="labeling/centroidWhole" value="false"/>
  <property key="labeling/decimals" value="3"/>
  <property key="labeling/displayAll" value="false"/>
  <property key="labeling/dist" value="0"/>
  <property key="labeling/distInMapUnits" value="false"/>
  <property key="labeling/distMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/drawLabels" value="false"/>
  <property key="labeling/enabled" value="false"/>
  <property key="labeling/fieldName" value=""/>
  <property key="labeling/fitInPolygonOnly" value="false"/>
  <property key="labeling/fontCapitals" value="0"/>
  <property key="labeling/fontFamily" value=".SF NS Text"/>
  <property key="labeling/fontItalic" value="false"/>
  <property key="labeling/fontLetterSpacing" value="0"/>
  <property key="labeling/fontLimitPixelSize" value="false"/>
  <property key="labeling/fontMaxPixelSize" value="10000"/>
  <property key="labeling/fontMinPixelSize" value="3"/>
  <property key="labeling/fontSize" value="13"/>
  <property key="labeling/fontSizeInMapUnits" value="false"/>
  <property key="labeling/fontSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/fontStrikeout" value="false"/>
  <property key="labeling/fontUnderline" value="false"/>
  <property key="labeling/fontWeight" value="50"/>
  <property key="labeling/fontWordSpacing" value="0"/>
  <property key="labeling/formatNumbers" value="false"/>
  <property key="labeling/isExpression" value="true"/>
  <property key="labeling/labelOffsetInMapUnits" value="true"/>
  <property key="labeling/labelOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/labelPerPart" value="false"/>
  <property key="labeling/leftDirectionSymbol" value="&lt;"/>
  <property key="labeling/limitNumLabels" value="false"/>
  <property key="labeling/maxCurvedCharAngleIn" value="20"/>
  <property key="labeling/maxCurvedCharAngleOut" value="-20"/>
  <property key="labeling/maxNumLabels" value="2000"/>
  <property key="labeling/mergeLines" value="false"/>
  <property key="labeling/minFeatureSize" value="0"/>
  <property key="labeling/multilineAlign" value="0"/>
  <property key="labeling/multilineHeight" value="1"/>
  <property key="labeling/namedStyle" value=""/>
  <property key="labeling/obstacle" value="true"/>
  <property key="labeling/obstacleFactor" value="1"/>
  <property key="labeling/obstacleType" value="0"/>
  <property key="labeling/offsetType" value="0"/>
  <property key="labeling/placeDirectionSymbol" value="0"/>
  <property key="labeling/placement" value="1"/>
  <property key="labeling/placementFlags" value="10"/>
  <property key="labeling/plussign" value="false"/>
  <property key="labeling/predefinedPositionOrder" value="TR,TL,BR,BL,R,L,TSR,BSR"/>
  <property key="labeling/preserveRotation" value="true"/>
  <property key="labeling/previewBkgrdColor" value="#ffffff"/>
  <property key="labeling/priority" value="5"/>
  <property key="labeling/quadOffset" value="4"/>
  <property key="labeling/repeatDistance" value="0"/>
  <property key="labeling/repeatDistanceMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/repeatDistanceUnit" value="1"/>
  <property key="labeling/reverseDirectionSymbol" value="false"/>
  <property key="labeling/rightDirectionSymbol" value=">"/>
  <property key="labeling/scaleMax" value="10000000"/>
  <property key="labeling/scaleMin" value="1"/>
  <property key="labeling/scaleVisibility" value="false"/>
  <property key="labeling/shadowBlendMode" value="6"/>
  <property key="labeling/shadowColorB" value="0"/>
  <property key="labeling/shadowColorG" value="0"/>
  <property key="labeling/shadowColorR" value="0"/>
  <property key="labeling/shadowDraw" value="false"/>
  <property key="labeling/shadowOffsetAngle" value="135"/>
  <property key="labeling/shadowOffsetDist" value="1"/>
  <property key="labeling/shadowOffsetGlobal" value="true"/>
  <property key="labeling/shadowOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowOffsetUnits" value="1"/>
  <property key="labeling/shadowRadius" value="1.5"/>
  <property key="labeling/shadowRadiusAlphaOnly" value="false"/>
  <property key="labeling/shadowRadiusMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowRadiusUnits" value="1"/>
  <property key="labeling/shadowScale" value="100"/>
  <property key="labeling/shadowTransparency" value="30"/>
  <property key="labeling/shadowUnder" value="0"/>
  <property key="labeling/shapeBlendMode" value="0"/>
  <property key="labeling/shapeBorderColorA" value="255"/>
  <property key="labeling/shapeBorderColorB" value="128"/>
  <property key="labeling/shapeBorderColorG" value="128"/>
  <property key="labeling/shapeBorderColorR" value="128"/>
  <property key="labeling/shapeBorderWidth" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeBorderWidthUnits" value="1"/>
  <property key="labeling/shapeDraw" value="false"/>
  <property key="labeling/shapeFillColorA" value="255"/>
  <property key="labeling/shapeFillColorB" value="255"/>
  <property key="labeling/shapeFillColorG" value="255"/>
  <property key="labeling/shapeFillColorR" value="255"/>
  <property key="labeling/shapeJoinStyle" value="64"/>
  <property key="labeling/shapeOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeOffsetUnits" value="1"/>
  <property key="labeling/shapeOffsetX" value="0"/>
  <property key="labeling/shapeOffsetY" value="0"/>
  <property key="labeling/shapeRadiiMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeRadiiUnits" value="1"/>
  <property key="labeling/shapeRadiiX" value="0"/>
  <property key="labeling/shapeRadiiY" value="0"/>
  <property key="labeling/shapeRotation" value="0"/>
  <property key="labeling/shapeRotationType" value="0"/>
  <property key="labeling/shapeSVGFile" value=""/>
  <property key="labeling/shapeSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeSizeType" value="0"/>
  <property key="labeling/shapeSizeUnits" value="1"/>
  <property key="labeling/shapeSizeX" value="0"/>
  <property key="labeling/shapeSizeY" value="0"/>
  <property key="labeling/shapeTransparency" value="0"/>
  <property key="labeling/shapeType" value="0"/>
  <property key="labeling/textColorA" value="255"/>
  <property key="labeling/textColorB" value="0"/>
  <property key="labeling/textColorG" value="0"/>
  <property key="labeling/textColorR" value="0"/>
  <property key="labeling/textTransp" value="0"/>
  <property key="labeling/upsidedownLabels" value="0"/>
  <property key="labeling/wrapChar" value=""/>
  <property key="labeling/xOffset" value="0"/>
  <property key="labeling/yOffset" value="0"/>
  <property key="labeling/zIndex" value="0"/>
  <property key="variableNames" value="_fields_"/>
  <property key="variableValues" value=""/>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerTransparency>0</layerTransparency>
 <displayfield>name</displayfield>
 <label>0</label>
 <labelattributes>
  <label fieldname="" text="Label"/>
  <family fieldname="" name=".SF NS Text"/>
  <size fieldname="" units="pt" value="12"/>
  <bold fieldname="" on="0"/>
  <italic fieldname="" on="0"/>
  <underline fieldname="" on="0"/>
  <strikeout fieldname="" on="0"/>
  <color fieldname="" red="0" blue="0" green="0"/>
  <x fieldname=""/>
  <y fieldname=""/>
  <offset x="0" y="0" units="pt" yfieldname="" xfieldname=""/>
  <angle fieldname="" value="0" auto="0"/>
  <alignment fieldname="" value="center"/>
  <buffercolor fieldname="" red="255" blue="255" green="255"/>
  <buffersize fieldname="" units="pt" value="1"/>
  <bufferenabled fieldname="" on=""/>
  <multilineenabled fieldname="" on=""/>
  <selectedonly on=""/>
 </labelattributes>
 <LinearlyInterpolatedDiagramRenderer upperValue="0" lowerHeight="0" upperHeight="50" lowerValue="0" diagramType="Histogram" upperWidth="50" classificationAttributeExpression="" lowerWidth="0">
  <DiagramCategory penColor="#000000" labelPlacementMethod="XHeight" penWidth="0" diagramOrientation="Up" minimumSize="0" barWidth="5" penAlpha="255" maxScaleDenominator="1e+08" backgroundColor="#ffffff" transparency="0" width="15" scaleDependency="Area" backgroundAlpha="255" angleOffset="1440" scaleBasedVisibility="0" enabled="0" height="15" sizeType="MM" minScaleDenominator="100000">
   <fontProperties description=".SF NS Text,13,-1,5,50,0,0,0,0,0" style=""/>
   <attribute field="" color="#000000" label=""/>
  </DiagramCategory>
 </LinearlyInterpolatedDiagramRenderer>
 <DiagramLayerSettings yPosColumn="-1" linePlacementFlags="10" placement="0" dist="0" xPosColumn="-1" priority="0" obstacle="0" zIndex="0" showAll="1"/>
 <annotationform>.</annotationform>
 <excludeAttributesWMS/>
 <excludeAttributesWFS/>
 <attributeactions/>
 <editform>.</editform>
 <editforminit/>
 <editforminitcodesource>0</editforminitcodesource>
 <editforminitfilepath>.</editforminitfilepath>
 <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
 <featformsuppress>0</featformsuppress>
 <editorlayout>generatedlayout</editorlayout>
 <widgets/>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
 <layerGeometryType>2</layerGeometryType>
</qgis>
', '<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0" xmlns:xlink="http://www.w3.org/1999/xlink" units="mm" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:se="http://www.opengis.net/se">
 <NamedLayer>
  <se:Name>osm_buildings</se:Name>
  <UserStyle>
   <se:Name>osm_buildings</se:Name>
   <se:FeatureTypeStyle>
    <se:Rule>
     <se:Name>Single symbol</se:Name>
     <se:PolygonSymbolizer>
      <se:Fill>
       <se:SvgParameter name="fill">#b4b4b4</se:SvgParameter>
      </se:Fill>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
   </se:FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
', true, 'Wed Jul 20 01:44:05 2016', 'docker', NULL, '2016-07-19 18:44:05.358674');
INSERT INTO layer_styles VALUES (2, 'gis', 'public', 'osm_places', 'geometry', 'osm_places', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="2.14.3-Essen" minimumScale="1" maximumScale="176471" simplifyDrawingHints="0" minLabelScale="0" maxLabelScale="1e+08" simplifyDrawingTol="1" simplifyMaxScale="1" hasScaleBasedVisibilityFlag="1" simplifyLocal="1" scaleBasedLabelVisibilityFlag="0">
 <edittypes>
  <edittype widgetv2type="TextEdit" name="id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="osm_id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="name">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="type">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="z_order">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="population">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
 </edittypes>
 <renderer-v2 forceraster="0" symbollevels="0" type="RuleRenderer" enableorderby="0">
  <rules key="{f710a058-4eb6-4290-b222-3982e1c003d9}">
   <rule filter="type = ''city''" key="{490f8cc0-701c-4a30-a3ef-6f1806a3edbc}" symbol="0" label="city"/>
   <rule filter="type = ''hamlet''" key="{578c7284-6dd7-4500-a443-06014b8f765f}" symbol="1" label="hamlet"/>
   <rule filter="type = ''locality''" key="{6d19cdc3-3af3-4a89-8998-205c65d31cd4}" symbol="2" label="locality"/>
   <rule filter="type = ''state''" key="{53054efb-3836-4e89-a38d-19f1bef8d57b}" symbol="3" label="state"/>
   <rule filter="type = ''suburb''" key="{1f2c8ac3-c78e-48f0-9a7a-c6690ae2bb79}" symbol="4" label="suburb"/>
   <rule filter="type = ''town''" key="{047c8e17-47ea-454f-9b2a-21573cd3159e}" symbol="5" label="town"/>
   <rule filter="type = ''village''" key="{1457b7fb-7655-43b0-a1a8-934d9d3349e6}" symbol="6" label="village"/>
  </rules>
  <symbols>
   <symbol alpha="1" clip_to_extent="1" type="marker" name="0">
    <layer pass="0" class="SimpleMarker" locked="0">
     <prop k="angle" v="0"/>
     <prop k="color" v="227,26,28,255"/>
     <prop k="horizontal_anchor_point" v="1"/>
     <prop k="name" v="star"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="scale_method" v="area"/>
     <prop k="size" v="5.2"/>
     <prop k="size_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="size_unit" v="MM"/>
     <prop k="vertical_anchor_point" v="1"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="marker" name="1">
    <layer pass="0" class="SimpleMarker" locked="0">
     <prop k="angle" v="0"/>
     <prop k="color" v="220,49,235,255"/>
     <prop k="horizontal_anchor_point" v="1"/>
     <prop k="name" v="circle"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="scale_method" v="diameter"/>
     <prop k="size" v="1"/>
     <prop k="size_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="size_unit" v="MM"/>
     <prop k="vertical_anchor_point" v="1"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="marker" name="2">
    <layer pass="0" class="SimpleMarker" locked="0">
     <prop k="angle" v="0"/>
     <prop k="color" v="136,196,238,255"/>
     <prop k="horizontal_anchor_point" v="1"/>
     <prop k="name" v="circle"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="scale_method" v="diameter"/>
     <prop k="size" v="1.4"/>
     <prop k="size_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="size_unit" v="MM"/>
     <prop k="vertical_anchor_point" v="1"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="marker" name="3">
    <layer pass="0" class="SimpleMarker" locked="0">
     <prop k="angle" v="0"/>
     <prop k="color" v="83,60,201,255"/>
     <prop k="horizontal_anchor_point" v="1"/>
     <prop k="name" v="circle"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="scale_method" v="diameter"/>
     <prop k="size" v="3.8"/>
     <prop k="size_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="size_unit" v="MM"/>
     <prop k="vertical_anchor_point" v="1"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="marker" name="4">
    <layer pass="0" class="SimpleMarker" locked="0">
     <prop k="angle" v="0"/>
     <prop k="color" v="178,208,26,255"/>
     <prop k="horizontal_anchor_point" v="1"/>
     <prop k="name" v="circle"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="scale_method" v="diameter"/>
     <prop k="size" v="2"/>
     <prop k="size_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="size_unit" v="MM"/>
     <prop k="vertical_anchor_point" v="1"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="marker" name="5">
    <layer pass="0" class="SimpleMarker" locked="0">
     <prop k="angle" v="0"/>
     <prop k="color" v="225,22,93,255"/>
     <prop k="horizontal_anchor_point" v="1"/>
     <prop k="name" v="circle"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="scale_method" v="diameter"/>
     <prop k="size" v="3"/>
     <prop k="size_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="size_unit" v="MM"/>
     <prop k="vertical_anchor_point" v="1"/>
    </layer>
   </symbol>
   <symbol alpha="1" clip_to_extent="1" type="marker" name="6">
    <layer pass="0" class="SimpleMarker" locked="0">
     <prop k="angle" v="0"/>
     <prop k="color" v="91,209,170,255"/>
     <prop k="horizontal_anchor_point" v="1"/>
     <prop k="name" v="circle"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="solid"/>
     <prop k="outline_width" v="0"/>
     <prop k="outline_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="scale_method" v="diameter"/>
     <prop k="size" v="2"/>
     <prop k="size_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="size_unit" v="MM"/>
     <prop k="vertical_anchor_point" v="1"/>
    </layer>
   </symbol>
  </symbols>
 </renderer-v2>
 <labeling type="simple"/>
 <customproperties>
  <property key="labeling" value="pal"/>
  <property key="labeling/addDirectionSymbol" value="false"/>
  <property key="labeling/angleOffset" value="0"/>
  <property key="labeling/blendMode" value="0"/>
  <property key="labeling/bufferBlendMode" value="0"/>
  <property key="labeling/bufferColorA" value="255"/>
  <property key="labeling/bufferColorB" value="255"/>
  <property key="labeling/bufferColorG" value="255"/>
  <property key="labeling/bufferColorR" value="255"/>
  <property key="labeling/bufferDraw" value="false"/>
  <property key="labeling/bufferJoinStyle" value="64"/>
  <property key="labeling/bufferNoFill" value="false"/>
  <property key="labeling/bufferSize" value="1"/>
  <property key="labeling/bufferSizeInMapUnits" value="false"/>
  <property key="labeling/bufferSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/bufferSizeMapUnitMinScale" value="0"/>
  <property key="labeling/bufferSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/bufferTransp" value="0"/>
  <property key="labeling/centroidInside" value="false"/>
  <property key="labeling/centroidWhole" value="false"/>
  <property key="labeling/decimals" value="3"/>
  <property key="labeling/displayAll" value="false"/>
  <property key="labeling/dist" value="0"/>
  <property key="labeling/distInMapUnits" value="false"/>
  <property key="labeling/distMapUnitMaxScale" value="0"/>
  <property key="labeling/distMapUnitMinScale" value="0"/>
  <property key="labeling/distMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/drawLabels" value="false"/>
  <property key="labeling/enabled" value="false"/>
  <property key="labeling/fieldName" value=""/>
  <property key="labeling/fitInPolygonOnly" value="false"/>
  <property key="labeling/fontCapitals" value="0"/>
  <property key="labeling/fontFamily" value=".SF NS Text"/>
  <property key="labeling/fontItalic" value="false"/>
  <property key="labeling/fontLetterSpacing" value="0"/>
  <property key="labeling/fontLimitPixelSize" value="false"/>
  <property key="labeling/fontMaxPixelSize" value="10000"/>
  <property key="labeling/fontMinPixelSize" value="3"/>
  <property key="labeling/fontSize" value="13.5"/>
  <property key="labeling/fontSizeInMapUnits" value="false"/>
  <property key="labeling/fontSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/fontSizeMapUnitMinScale" value="0"/>
  <property key="labeling/fontSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/fontStrikeout" value="false"/>
  <property key="labeling/fontUnderline" value="false"/>
  <property key="labeling/fontWeight" value="63"/>
  <property key="labeling/fontWordSpacing" value="0"/>
  <property key="labeling/formatNumbers" value="false"/>
  <property key="labeling/isExpression" value="true"/>
  <property key="labeling/labelOffsetInMapUnits" value="true"/>
  <property key="labeling/labelOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/labelOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/labelOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/labelPerPart" value="false"/>
  <property key="labeling/leftDirectionSymbol" value="&lt;"/>
  <property key="labeling/limitNumLabels" value="false"/>
  <property key="labeling/maxCurvedCharAngleIn" value="20"/>
  <property key="labeling/maxCurvedCharAngleOut" value="-20"/>
  <property key="labeling/maxNumLabels" value="2000"/>
  <property key="labeling/mergeLines" value="false"/>
  <property key="labeling/minFeatureSize" value="0"/>
  <property key="labeling/multilineAlign" value="0"/>
  <property key="labeling/multilineHeight" value="1"/>
  <property key="labeling/namedStyle" value=""/>
  <property key="labeling/obstacle" value="true"/>
  <property key="labeling/obstacleFactor" value="1"/>
  <property key="labeling/obstacleType" value="0"/>
  <property key="labeling/offsetType" value="0"/>
  <property key="labeling/placeDirectionSymbol" value="0"/>
  <property key="labeling/placement" value="0"/>
  <property key="labeling/placementFlags" value="10"/>
  <property key="labeling/plussign" value="false"/>
  <property key="labeling/predefinedPositionOrder" value="TR,TL,BR,BL,R,L,TSR,BSR"/>
  <property key="labeling/preserveRotation" value="true"/>
  <property key="labeling/previewBkgrdColor" value="#ffffff"/>
  <property key="labeling/priority" value="5"/>
  <property key="labeling/quadOffset" value="4"/>
  <property key="labeling/repeatDistance" value="0"/>
  <property key="labeling/repeatDistanceMapUnitMaxScale" value="0"/>
  <property key="labeling/repeatDistanceMapUnitMinScale" value="0"/>
  <property key="labeling/repeatDistanceMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/repeatDistanceUnit" value="1"/>
  <property key="labeling/reverseDirectionSymbol" value="false"/>
  <property key="labeling/rightDirectionSymbol" value=">"/>
  <property key="labeling/scaleMax" value="10000000"/>
  <property key="labeling/scaleMin" value="1"/>
  <property key="labeling/scaleVisibility" value="false"/>
  <property key="labeling/shadowBlendMode" value="6"/>
  <property key="labeling/shadowColorB" value="0"/>
  <property key="labeling/shadowColorG" value="0"/>
  <property key="labeling/shadowColorR" value="0"/>
  <property key="labeling/shadowDraw" value="false"/>
  <property key="labeling/shadowOffsetAngle" value="135"/>
  <property key="labeling/shadowOffsetDist" value="1"/>
  <property key="labeling/shadowOffsetGlobal" value="true"/>
  <property key="labeling/shadowOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/shadowOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/shadowOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowOffsetUnits" value="1"/>
  <property key="labeling/shadowRadius" value="1.5"/>
  <property key="labeling/shadowRadiusAlphaOnly" value="false"/>
  <property key="labeling/shadowRadiusMapUnitMaxScale" value="0"/>
  <property key="labeling/shadowRadiusMapUnitMinScale" value="0"/>
  <property key="labeling/shadowRadiusMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowRadiusUnits" value="1"/>
  <property key="labeling/shadowScale" value="100"/>
  <property key="labeling/shadowTransparency" value="30"/>
  <property key="labeling/shadowUnder" value="0"/>
  <property key="labeling/shapeBlendMode" value="0"/>
  <property key="labeling/shapeBorderColorA" value="255"/>
  <property key="labeling/shapeBorderColorB" value="128"/>
  <property key="labeling/shapeBorderColorG" value="128"/>
  <property key="labeling/shapeBorderColorR" value="128"/>
  <property key="labeling/shapeBorderWidth" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitMinScale" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeBorderWidthUnits" value="1"/>
  <property key="labeling/shapeDraw" value="false"/>
  <property key="labeling/shapeFillColorA" value="255"/>
  <property key="labeling/shapeFillColorB" value="255"/>
  <property key="labeling/shapeFillColorG" value="255"/>
  <property key="labeling/shapeFillColorR" value="255"/>
  <property key="labeling/shapeJoinStyle" value="64"/>
  <property key="labeling/shapeOffsetMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeOffsetMapUnitMinScale" value="0"/>
  <property key="labeling/shapeOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeOffsetUnits" value="1"/>
  <property key="labeling/shapeOffsetX" value="0"/>
  <property key="labeling/shapeOffsetY" value="0"/>
  <property key="labeling/shapeRadiiMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeRadiiMapUnitMinScale" value="0"/>
  <property key="labeling/shapeRadiiMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeRadiiUnits" value="1"/>
  <property key="labeling/shapeRadiiX" value="0"/>
  <property key="labeling/shapeRadiiY" value="0"/>
  <property key="labeling/shapeRotation" value="0"/>
  <property key="labeling/shapeRotationType" value="0"/>
  <property key="labeling/shapeSVGFile" value=""/>
  <property key="labeling/shapeSizeMapUnitMaxScale" value="0"/>
  <property key="labeling/shapeSizeMapUnitMinScale" value="0"/>
  <property key="labeling/shapeSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeSizeType" value="0"/>
  <property key="labeling/shapeSizeUnits" value="1"/>
  <property key="labeling/shapeSizeX" value="0"/>
  <property key="labeling/shapeSizeY" value="0"/>
  <property key="labeling/shapeTransparency" value="0"/>
  <property key="labeling/shapeType" value="0"/>
  <property key="labeling/textColorA" value="255"/>
  <property key="labeling/textColorB" value="0"/>
  <property key="labeling/textColorG" value="0"/>
  <property key="labeling/textColorR" value="0"/>
  <property key="labeling/textTransp" value="0"/>
  <property key="labeling/upsidedownLabels" value="0"/>
  <property key="labeling/wrapChar" value=""/>
  <property key="labeling/xOffset" value="0"/>
  <property key="labeling/yOffset" value="0"/>
  <property key="labeling/zIndex" value="0"/>
  <property key="variableNames" value="_fields_"/>
  <property key="variableValues" value=""/>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerTransparency>0</layerTransparency>
 <displayfield>name</displayfield>
 <label>0</label>
 <labelattributes>
  <label fieldname="" text="Label"/>
  <family fieldname="" name="Ubuntu"/>
  <size fieldname="" units="pt" value="12"/>
  <bold fieldname="" on="0"/>
  <italic fieldname="" on="0"/>
  <underline fieldname="" on="0"/>
  <strikeout fieldname="" on="0"/>
  <color fieldname="" red="0" blue="0" green="0"/>
  <x fieldname=""/>
  <y fieldname=""/>
  <offset x="0" y="0" units="pt" yfieldname="" xfieldname=""/>
  <angle fieldname="" value="0" auto="0"/>
  <alignment fieldname="" value="center"/>
  <buffercolor fieldname="" red="255" blue="255" green="255"/>
  <buffersize fieldname="" units="pt" value="1"/>
  <bufferenabled fieldname="" on=""/>
  <multilineenabled fieldname="" on=""/>
  <selectedonly on=""/>
 </labelattributes>
 <SingleCategoryDiagramRenderer diagramType="Pie">
  <DiagramCategory penColor="#000000" labelPlacementMethod="XHeight" penWidth="0" diagramOrientation="Up" minimumSize="0" barWidth="5" penAlpha="255" maxScaleDenominator="1e+08" backgroundColor="#ffffff" transparency="0" width="15" scaleDependency="Area" backgroundAlpha="255" angleOffset="1440" scaleBasedVisibility="0" enabled="0" height="15" sizeType="MM" minScaleDenominator="1">
   <fontProperties description="Ubuntu,13.5,-1,5,50,0,0,0,0,0" style=""/>
   <attribute field="" color="#000000" label=""/>
  </DiagramCategory>
 </SingleCategoryDiagramRenderer>
 <DiagramLayerSettings yPosColumn="-1" linePlacementFlags="10" placement="0" dist="0" xPosColumn="-1" priority="0" obstacle="0" zIndex="0" showAll="1"/>
 <annotationform>.</annotationform>
 <excludeAttributesWMS/>
 <excludeAttributesWFS/>
 <attributeactions/>
 <editform>.</editform>
 <editforminit/>
 <editforminitcodesource>0</editforminitcodesource>
 <editforminitfilepath>.</editforminitfilepath>
 <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from PyQt4.QtGui import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
 <featformsuppress>0</featformsuppress>
 <editorlayout>generatedlayout</editorlayout>
 <widgets/>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
 <layerGeometryType>0</layerGeometryType>
</qgis>
', '<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0" xmlns:xlink="http://www.w3.org/1999/xlink" units="mm" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:se="http://www.opengis.net/se">
 <NamedLayer>
  <se:Name>osm_places</se:Name>
  <UserStyle>
   <se:Name>osm_places</se:Name>
   <se:FeatureTypeStyle>
    <se:Rule>
     <se:Name>city</se:Name>
     <se:Description>
      <se:Title>city</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>city</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PointSymbolizer>
      <se:Graphic>
       <se:Mark>
        <se:WellKnownName>star</se:WellKnownName>
        <se:Fill>
         <se:SvgParameter name="fill">#e31a1c</se:SvgParameter>
        </se:Fill>
        <se:Stroke>
         <se:SvgParameter name="stroke">#000000</se:SvgParameter>
        </se:Stroke>
       </se:Mark>
       <se:Size>5.2</se:Size>
      </se:Graphic>
     </se:PointSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>hamlet</se:Name>
     <se:Description>
      <se:Title>hamlet</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>hamlet</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PointSymbolizer>
      <se:Graphic>
       <se:Mark>
        <se:WellKnownName>circle</se:WellKnownName>
        <se:Fill>
         <se:SvgParameter name="fill">#dc31eb</se:SvgParameter>
        </se:Fill>
        <se:Stroke>
         <se:SvgParameter name="stroke">#000000</se:SvgParameter>
        </se:Stroke>
       </se:Mark>
       <se:Size>1</se:Size>
      </se:Graphic>
     </se:PointSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>locality</se:Name>
     <se:Description>
      <se:Title>locality</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>locality</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PointSymbolizer>
      <se:Graphic>
       <se:Mark>
        <se:WellKnownName>circle</se:WellKnownName>
        <se:Fill>
         <se:SvgParameter name="fill">#88c4ee</se:SvgParameter>
        </se:Fill>
        <se:Stroke>
         <se:SvgParameter name="stroke">#000000</se:SvgParameter>
        </se:Stroke>
       </se:Mark>
       <se:Size>1.4</se:Size>
      </se:Graphic>
     </se:PointSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>state</se:Name>
     <se:Description>
      <se:Title>state</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>state</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PointSymbolizer>
      <se:Graphic>
       <se:Mark>
        <se:WellKnownName>circle</se:WellKnownName>
        <se:Fill>
         <se:SvgParameter name="fill">#533cc9</se:SvgParameter>
        </se:Fill>
        <se:Stroke>
         <se:SvgParameter name="stroke">#000000</se:SvgParameter>
        </se:Stroke>
       </se:Mark>
       <se:Size>3.8</se:Size>
      </se:Graphic>
     </se:PointSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>suburb</se:Name>
     <se:Description>
      <se:Title>suburb</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>suburb</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PointSymbolizer>
      <se:Graphic>
       <se:Mark>
        <se:WellKnownName>circle</se:WellKnownName>
        <se:Fill>
         <se:SvgParameter name="fill">#b2d01a</se:SvgParameter>
        </se:Fill>
        <se:Stroke>
         <se:SvgParameter name="stroke">#000000</se:SvgParameter>
        </se:Stroke>
       </se:Mark>
       <se:Size>2</se:Size>
      </se:Graphic>
     </se:PointSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>town</se:Name>
     <se:Description>
      <se:Title>town</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>town</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PointSymbolizer>
      <se:Graphic>
       <se:Mark>
        <se:WellKnownName>circle</se:WellKnownName>
        <se:Fill>
         <se:SvgParameter name="fill">#e1165d</se:SvgParameter>
        </se:Fill>
        <se:Stroke>
         <se:SvgParameter name="stroke">#000000</se:SvgParameter>
        </se:Stroke>
       </se:Mark>
       <se:Size>3</se:Size>
      </se:Graphic>
     </se:PointSymbolizer>
    </se:Rule>
    <se:Rule>
     <se:Name>village</se:Name>
     <se:Description>
      <se:Title>village</se:Title>
     </se:Description>
     <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>type</ogc:PropertyName>
       <ogc:Literal>village</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <se:PointSymbolizer>
      <se:Graphic>
       <se:Mark>
        <se:WellKnownName>circle</se:WellKnownName>
        <se:Fill>
         <se:SvgParameter name="fill">#5bd1aa</se:SvgParameter>
        </se:Fill>
        <se:Stroke>
         <se:SvgParameter name="stroke">#000000</se:SvgParameter>
        </se:Stroke>
       </se:Mark>
       <se:Size>2</se:Size>
      </se:Graphic>
     </se:PointSymbolizer>
    </se:Rule>
   </se:FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
', true, 'Wed Jul 20 01:43:55 2016', 'docker', NULL, '2015-12-22 09:20:12.897576');
INSERT INTO layer_styles VALUES (7, 'gis', 'public', 'osm_admin', 'geometry', 'osm_admin', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="2.14.3-Essen" minimumScale="100000" maximumScale="1e+08" simplifyDrawingHints="1" minLabelScale="0" maxLabelScale="1e+08" simplifyDrawingTol="1" simplifyMaxScale="1" hasScaleBasedVisibilityFlag="0" simplifyLocal="1" scaleBasedLabelVisibilityFlag="0">
 <edittypes>
  <edittype widgetv2type="TextEdit" name="id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="osm_id">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="name">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="type">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
  <edittype widgetv2type="TextEdit" name="admin_level">
   <widgetv2config IsMultiline="0" fieldEditable="1" UseHtml="0" labelOnTop="0"/>
  </edittype>
 </edittypes>
 <renderer-v2 forceraster="0" symbollevels="0" type="singleSymbol" enableorderby="0">
  <symbols>
   <symbol alpha="1" clip_to_extent="1" type="fill" name="0">
    <layer pass="0" class="SimpleFill" locked="0">
     <prop k="border_width_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="color" v="65,160,114,255"/>
     <prop k="joinstyle" v="bevel"/>
     <prop k="offset" v="0,0"/>
     <prop k="offset_map_unit_scale" v="0,0,0,0,0,0"/>
     <prop k="offset_unit" v="MM"/>
     <prop k="outline_color" v="0,0,0,255"/>
     <prop k="outline_style" v="dash"/>
     <prop k="outline_width" v="0.26"/>
     <prop k="outline_width_unit" v="MM"/>
     <prop k="style" v="no"/>
    </layer>
   </symbol>
  </symbols>
  <rotation/>
  <sizescale scalemethod="diameter"/>
 </renderer-v2>
 <labeling type="simple"/>
 <customproperties>
  <property key="embeddedWidgets/count" value="0"/>
  <property key="labeling" value="pal"/>
  <property key="labeling/addDirectionSymbol" value="false"/>
  <property key="labeling/angleOffset" value="0"/>
  <property key="labeling/blendMode" value="0"/>
  <property key="labeling/bufferBlendMode" value="0"/>
  <property key="labeling/bufferColorA" value="255"/>
  <property key="labeling/bufferColorB" value="255"/>
  <property key="labeling/bufferColorG" value="255"/>
  <property key="labeling/bufferColorR" value="255"/>
  <property key="labeling/bufferDraw" value="false"/>
  <property key="labeling/bufferJoinStyle" value="64"/>
  <property key="labeling/bufferNoFill" value="false"/>
  <property key="labeling/bufferSize" value="1"/>
  <property key="labeling/bufferSizeInMapUnits" value="false"/>
  <property key="labeling/bufferSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/bufferTransp" value="0"/>
  <property key="labeling/centroidInside" value="false"/>
  <property key="labeling/centroidWhole" value="false"/>
  <property key="labeling/decimals" value="3"/>
  <property key="labeling/displayAll" value="false"/>
  <property key="labeling/dist" value="0"/>
  <property key="labeling/distInMapUnits" value="false"/>
  <property key="labeling/distMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/drawLabels" value="true"/>
  <property key="labeling/enabled" value="true"/>
  <property key="labeling/fieldName" value="name"/>
  <property key="labeling/fitInPolygonOnly" value="false"/>
  <property key="labeling/fontCapitals" value="0"/>
  <property key="labeling/fontFamily" value=".SF NS Text"/>
  <property key="labeling/fontItalic" value="false"/>
  <property key="labeling/fontLetterSpacing" value="0"/>
  <property key="labeling/fontLimitPixelSize" value="false"/>
  <property key="labeling/fontMaxPixelSize" value="10000"/>
  <property key="labeling/fontMinPixelSize" value="3"/>
  <property key="labeling/fontSize" value="13"/>
  <property key="labeling/fontSizeInMapUnits" value="false"/>
  <property key="labeling/fontSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/fontStrikeout" value="false"/>
  <property key="labeling/fontUnderline" value="false"/>
  <property key="labeling/fontWeight" value="50"/>
  <property key="labeling/fontWordSpacing" value="0"/>
  <property key="labeling/formatNumbers" value="false"/>
  <property key="labeling/isExpression" value="false"/>
  <property key="labeling/labelOffsetInMapUnits" value="true"/>
  <property key="labeling/labelOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/labelPerPart" value="false"/>
  <property key="labeling/leftDirectionSymbol" value="&lt;"/>
  <property key="labeling/limitNumLabels" value="false"/>
  <property key="labeling/maxCurvedCharAngleIn" value="20"/>
  <property key="labeling/maxCurvedCharAngleOut" value="-20"/>
  <property key="labeling/maxNumLabels" value="2000"/>
  <property key="labeling/mergeLines" value="false"/>
  <property key="labeling/minFeatureSize" value="0"/>
  <property key="labeling/multilineAlign" value="0"/>
  <property key="labeling/multilineHeight" value="1"/>
  <property key="labeling/namedStyle" value=""/>
  <property key="labeling/obstacle" value="true"/>
  <property key="labeling/obstacleFactor" value="1"/>
  <property key="labeling/obstacleType" value="0"/>
  <property key="labeling/offsetType" value="0"/>
  <property key="labeling/placeDirectionSymbol" value="0"/>
  <property key="labeling/placement" value="1"/>
  <property key="labeling/placementFlags" value="10"/>
  <property key="labeling/plussign" value="false"/>
  <property key="labeling/predefinedPositionOrder" value="TR,TL,BR,BL,R,L,TSR,BSR"/>
  <property key="labeling/preserveRotation" value="true"/>
  <property key="labeling/previewBkgrdColor" value="#ffffff"/>
  <property key="labeling/priority" value="5"/>
  <property key="labeling/quadOffset" value="4"/>
  <property key="labeling/repeatDistance" value="0"/>
  <property key="labeling/repeatDistanceMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/repeatDistanceUnit" value="1"/>
  <property key="labeling/reverseDirectionSymbol" value="false"/>
  <property key="labeling/rightDirectionSymbol" value=">"/>
  <property key="labeling/scaleMax" value="1400000"/>
  <property key="labeling/scaleMin" value="1"/>
  <property key="labeling/scaleVisibility" value="true"/>
  <property key="labeling/shadowBlendMode" value="6"/>
  <property key="labeling/shadowColorB" value="0"/>
  <property key="labeling/shadowColorG" value="0"/>
  <property key="labeling/shadowColorR" value="0"/>
  <property key="labeling/shadowDraw" value="false"/>
  <property key="labeling/shadowOffsetAngle" value="135"/>
  <property key="labeling/shadowOffsetDist" value="1"/>
  <property key="labeling/shadowOffsetGlobal" value="true"/>
  <property key="labeling/shadowOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowOffsetUnits" value="1"/>
  <property key="labeling/shadowRadius" value="1.5"/>
  <property key="labeling/shadowRadiusAlphaOnly" value="false"/>
  <property key="labeling/shadowRadiusMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shadowRadiusUnits" value="1"/>
  <property key="labeling/shadowScale" value="100"/>
  <property key="labeling/shadowTransparency" value="30"/>
  <property key="labeling/shadowUnder" value="0"/>
  <property key="labeling/shapeBlendMode" value="0"/>
  <property key="labeling/shapeBorderColorA" value="255"/>
  <property key="labeling/shapeBorderColorB" value="128"/>
  <property key="labeling/shapeBorderColorG" value="128"/>
  <property key="labeling/shapeBorderColorR" value="128"/>
  <property key="labeling/shapeBorderWidth" value="0"/>
  <property key="labeling/shapeBorderWidthMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeBorderWidthUnits" value="1"/>
  <property key="labeling/shapeDraw" value="false"/>
  <property key="labeling/shapeFillColorA" value="255"/>
  <property key="labeling/shapeFillColorB" value="255"/>
  <property key="labeling/shapeFillColorG" value="255"/>
  <property key="labeling/shapeFillColorR" value="255"/>
  <property key="labeling/shapeJoinStyle" value="64"/>
  <property key="labeling/shapeOffsetMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeOffsetUnits" value="1"/>
  <property key="labeling/shapeOffsetX" value="0"/>
  <property key="labeling/shapeOffsetY" value="0"/>
  <property key="labeling/shapeRadiiMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeRadiiUnits" value="1"/>
  <property key="labeling/shapeRadiiX" value="0"/>
  <property key="labeling/shapeRadiiY" value="0"/>
  <property key="labeling/shapeRotation" value="0"/>
  <property key="labeling/shapeRotationType" value="0"/>
  <property key="labeling/shapeSVGFile" value=""/>
  <property key="labeling/shapeSizeMapUnitScale" value="0,0,0,0,0,0"/>
  <property key="labeling/shapeSizeType" value="0"/>
  <property key="labeling/shapeSizeUnits" value="1"/>
  <property key="labeling/shapeSizeX" value="0"/>
  <property key="labeling/shapeSizeY" value="0"/>
  <property key="labeling/shapeTransparency" value="0"/>
  <property key="labeling/shapeType" value="0"/>
  <property key="labeling/textColorA" value="255"/>
  <property key="labeling/textColorB" value="0"/>
  <property key="labeling/textColorG" value="0"/>
  <property key="labeling/textColorR" value="0"/>
  <property key="labeling/textTransp" value="0"/>
  <property key="labeling/upsidedownLabels" value="0"/>
  <property key="labeling/wrapChar" value=""/>
  <property key="labeling/xOffset" value="0"/>
  <property key="labeling/yOffset" value="0"/>
  <property key="labeling/zIndex" value="0"/>
  <property key="variableNames" value="_fields_"/>
  <property key="variableValues" value=""/>
 </customproperties>
 <blendMode>0</blendMode>
 <featureBlendMode>0</featureBlendMode>
 <layerTransparency>0</layerTransparency>
 <displayfield>name</displayfield>
 <label>0</label>
 <labelattributes>
  <label fieldname="" text="Label"/>
  <family fieldname="" name=".SF NS Text"/>
  <size fieldname="" units="pt" value="12"/>
  <bold fieldname="" on="0"/>
  <italic fieldname="" on="0"/>
  <underline fieldname="" on="0"/>
  <strikeout fieldname="" on="0"/>
  <color fieldname="" red="0" blue="0" green="0"/>
  <x fieldname=""/>
  <y fieldname=""/>
  <offset x="0" y="0" units="pt" yfieldname="" xfieldname=""/>
  <angle fieldname="" value="0" auto="0"/>
  <alignment fieldname="" value="center"/>
  <buffercolor fieldname="" red="255" blue="255" green="255"/>
  <buffersize fieldname="" units="pt" value="1"/>
  <bufferenabled fieldname="" on=""/>
  <multilineenabled fieldname="" on=""/>
  <selectedonly on=""/>
 </labelattributes>
 <LinearlyInterpolatedDiagramRenderer upperValue="0" lowerHeight="0" upperHeight="50" lowerValue="0" diagramType="Histogram" upperWidth="50" classificationAttributeExpression="" lowerWidth="0">
  <DiagramCategory penColor="#000000" labelPlacementMethod="XHeight" penWidth="0" diagramOrientation="Up" minimumSize="0" barWidth="5" penAlpha="255" maxScaleDenominator="1e+08" backgroundColor="#ffffff" transparency="0" width="15" scaleDependency="Area" backgroundAlpha="255" angleOffset="1440" scaleBasedVisibility="0" enabled="0" height="15" sizeType="MM" minScaleDenominator="100000">
   <fontProperties description=".SF NS Text,13,-1,5,50,0,0,0,0,0" style=""/>
   <attribute field="" color="#000000" label=""/>
  </DiagramCategory>
 </LinearlyInterpolatedDiagramRenderer>
 <DiagramLayerSettings yPosColumn="-1" linePlacementFlags="10" placement="0" dist="0" xPosColumn="-1" priority="0" obstacle="0" zIndex="0" showAll="1"/>
 <annotationform>.</annotationform>
 <excludeAttributesWMS/>
 <excludeAttributesWFS/>
 <attributeactions/>
 <editform>.</editform>
 <editforminit/>
 <editforminitcodesource>0</editforminitcodesource>
 <editforminitfilepath>.</editforminitfilepath>
 <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
 <featformsuppress>0</featformsuppress>
 <editorlayout>generatedlayout</editorlayout>
 <widgets/>
 <conditionalstyles>
  <rowstyles/>
  <fieldstyles/>
 </conditionalstyles>
 <layerGeometryType>2</layerGeometryType>
</qgis>
', '<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0" xmlns:xlink="http://www.w3.org/1999/xlink" units="mm" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd" xmlns:se="http://www.opengis.net/se">
 <NamedLayer>
  <se:Name>osm_admin</se:Name>
  <UserStyle>
   <se:Name>osm_admin</se:Name>
   <se:FeatureTypeStyle>
    <se:Rule>
     <se:Name>Single symbol</se:Name>
     <se:PolygonSymbolizer>
      <se:Stroke>
       <se:SvgParameter name="stroke">#000000</se:SvgParameter>
       <se:SvgParameter name="stroke-width">0.26</se:SvgParameter>
       <se:SvgParameter name="stroke-linejoin">bevel</se:SvgParameter>
       <se:SvgParameter name="stroke-dasharray">4 2</se:SvgParameter>
      </se:Stroke>
     </se:PolygonSymbolizer>
    </se:Rule>
   </se:FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
', true, 'Wed Jul 20 01:44:15 2016', 'docker', NULL, '2016-07-19 18:44:15.125991');


--
-- Name: layer_styles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: docker
--

SELECT pg_catalog.setval('layer_styles_id_seq', 7, true);


--
-- Name: layer_styles_pkey; Type: CONSTRAINT; Schema: public; Owner: docker; Tablespace: 
--

ALTER TABLE ONLY layer_styles
    ADD CONSTRAINT layer_styles_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

