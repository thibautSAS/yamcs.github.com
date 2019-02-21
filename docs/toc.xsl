<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:outline="http://wkhtmltopdf.org/outline"
    xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
    indent="yes" />
  <xsl:template match="outline:outline">
    <html>
      <head>
        <title>Table of Contents</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <style>
          body {
            font-family: "Helvetica Neue", Arial, FreeSans, sans-serif;
            font-size: 11px;
            counter-reset: hcounter;
          }

          div.item {
            float: left;
            white-space: nowrap;
          }

          div.dotwrap {
            overflow: hidden;
          }

          div.dots {
            white-space: nowrap;
            font-family: "Helvetica Neue", Arial, FreeSans, sans-serif;
            font-size: 11px;
            float: right;
            font-weight: 200;
          }

          .page {
            text-align: right;
          }

          .page.chapter {
            font-weight: bold;
            font-size: 13px;
          }

          a {
            text-decoration:none;
            color: black;
            font-family: "Helvetica Neue", Arial, FreeSans, sans-serif;
            font-size: 11px;
          }
          .chapterno {
            font-weight: bold;
            font-size: 13px;
          }
          .chapterno:before {
            content: counter(hcounter) '.\0000a0\0000a0\0000a0\0000a0';
            counter-increment: hcounter;
          }
          a.chapter {
            font-weight: bold;
            white-space: nowrap;
            padding-right: 0.5em;
            font-size: 13px;
          }
          .chapterblock {
            font-size: 11px;
          }
          .chapterblock:after {
            /* This is just another trick to get it working through qt's xslt, which doesn't support unprocessed text */
            content: '\0000a0';
          }
        </style>
      </head>
      <body>
        <h1>Table of Contents</h1>
        <table style="table-layout: fixed; width: 100%">
          <xsl:apply-templates select="outline:item/outline:item">
            <xsl:with-param name="type">chapter</xsl:with-param>
          </xsl:apply-templates>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="outline:item">
    <xsl:param name="type" />
    <xsl:if test="@title!='Table of Contents'">
      <tr class="{$type}">
        <td style="width: 20px;">
          <xsl:if test="$type='chapter'">
            <a>
              <xsl:attribute name="href"><xsl:value-of select="@link"/></xsl:attribute>
              <span class="chapterno"></span>
            </a>
          </xsl:if>
        </td>
        <td>
          <div class="item">
            <a class="{$type}">
              <xsl:if test="@link">
                <xsl:attribute name="href"><xsl:value-of select="@link"/></xsl:attribute>
              </xsl:if>
              <xsl:if test="@backLink">
                <xsl:attribute name="name"><xsl:value-of select="@backLink"/></xsl:attribute>
              </xsl:if>
              <xsl:value-of select="@title" />
            </a>
          </div>
          <div class="dotwrap">
            <div class="dots" dir="rtl"> <!-- rtl to keep dots aligned across lines -->
              <xsl:if test="$type='chapter'">
                . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
              </xsl:if>
            </div>
          </div>
        </td>
        <td class="page {$type}" style="width: 20px;">
          <a>
            <xsl:attribute name="href"><xsl:value-of select="@link"/></xsl:attribute>
            <xsl:value-of select="@page" />
          </a>
        </td>
      </tr>

      <xsl:if test="$type='chapter'">
        <xsl:apply-templates select="outline:item">
          <xsl:with-param name="type">heading</xsl:with-param>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:if test="$type='chapter'">
        <tr><td class="chapterblock">&#160;</td></tr>
      </xsl:if>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
