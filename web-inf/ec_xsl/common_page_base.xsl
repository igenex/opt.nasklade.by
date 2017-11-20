<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [<!ENTITY nbsp "&#160;"><!ENTITY copy "&#x000A9;" >]>
<!-- optnasklade.must.by -->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:f="f:f"
	version="2.0">
	<xsl:import href="cart_ajax.xsl"/>
	<xsl:import href="seller_boss_ajax.xsl"/>
	<xsl:import href="personal_ajax.xsl"/>
	<xsl:import href="login_ajax.xsl"/>
	<xsl:import href="search_ajax.xsl"/>
	<xsl:import href="vote_ajax.xsl"/>
	<xsl:output method="xhtml" encoding="UTF-8" media-type="text/html" indent="yes" omit-xml-declaration="yes"/>

<xsl:variable name="show_menu" select="'no'"/>
<xsl:variable name="sec" select="//desc"/>

<xsl:template name="DOCTYPE">
<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;</xsl:text>
</xsl:template>

	<xsl:decimal-format name="rus" decimal-separator="." grouping-separator=" "/>

	<xsl:variable name="title"/>
	<xsl:variable name="keywords"/>
	<xsl:variable name="meta_description"/>
	<!-- <xsl:variable name="desc" select=""/> -->
	
	<xsl:variable name="is_registered" select="page/user/@group = 'registered'"/>
	<xsl:variable name="new_devices_news_id" select="('28342', '91333')"/>

	<xsl:template name="TITLE"><xsl:value-of select="$title"/> - nasklade.by</xsl:template>

	<xsl:template name="CONTENT"/>

	<xsl:template name="DELIVERY_DATE">
		<xsl:if test="page/dealers_promo/ship_where and page/dealers_promo/ship_where != '' and page/dealers_promo/ship_date != ''">
		
			<div class="delivery-date {page/@name}">
				Планируетя доствка на <xsl:value-of select="substring(page/dealers_promo/ship_date , 1, 10)"/>
				<br/>по направлению НИ <xsl:value-of select="page/dealers_promo/ship_where"/>
				<br/><a href="page/dostavka_dilery/">подробнее</a>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- ****************************    ГЛАВНОЕ МЕНЮ    ******************************** -->

	<xsl:template match="text_sections[text != '' or text_part or gallery_part] | page">
	<a href="{show_section}"><span><xsl:value-of select="name"/></span></a>
	</xsl:template>

	<xsl:template match="news">
	<span>
	<xsl:choose>
		<xsl:when test="@id = $new_devices_news_id"><a href="{//page/new_only_link}"><span>Новые поступления</span></a></xsl:when>
		<xsl:otherwise><a href="{show_news}"><span><xsl:value-of select="name"/></span></a></xsl:otherwise>
	</xsl:choose>
	</span>
	<span></span>
	</xsl:template>

	<xsl:template match="text_sections">
	<a href="{page[1]/show_page}"><span><xsl:value-of select="name"/></span></a>
	</xsl:template>

	<!-- ****************************    МЕНЮ КАТАЛОГА ПРОДУКЦИИ    ******************************** -->

	<xsl:variable name="dsec" select="//dsec"/>
	<xsl:variable name="sec_id" select="$dsec/code"/>
	
	<xsl:template name="CATALOG_MENU">
	<div id="catalogMenu" style="{'display: block;'[$show_menu = 'yes']}">
		<div class="cap">
			<div class="arrow"></div>
		</div>
		<div class="left" id="left_side">
			<xsl:apply-templates select="page/catalog_menu/desc_section" mode="first_index"/>				
		</div>
		<xsl:apply-templates select="page/catalog_menu/desc_section[desc_section]" mode="submenu_index"/>
		<div class="clear"></div>
	</div>
	<xsl:for-each select="//desc_section[short != '']">
	<div style="display:none" id="about_{@id}">
		<xsl:value-of select="short" disable-output-escaping="yes"/>
	</div>
	</xsl:for-each>
	</xsl:template>
	
	<!-- Меню первого уровня -->
	
	<xsl:template match="desc_section[desc_section]" mode="first_index">
		<xsl:variable name="last" select="position() = last()"/>
		<xsl:variable name="active" select=".//code = $sec_id"/>
		<a href="#right_{@id}" class="{'active '[$active]}{'last'[$last]}"><xsl:value-of select="name"/></a>
	</xsl:template>
	
	<xsl:template match="desc_section" mode="first_index">
		<xsl:variable name="last" select="position() = last()"/>
		<xsl:variable name="active" select=".//code = $sec_id"/>
		<a href="{show_section}" class="{'active '[$active]}{'last'[$last]}" title="перейти в каталог продукции"><xsl:value-of select="name"/></a>
	</xsl:template>
	
	<!-- Раскрывающееся поле для меню второго и третьего уровня -->
	
	<xsl:template match="desc_section" mode="submenu_index">
	<div class="right" id="right_{@id}" style="display: none">
		<h2>
			<xsl:value-of select="name"/>
			<a class="lv1-a" href="{show_section}" style="float: right; font-size: 14px; line-height: 30px; margin-top: 20px; font-weight: normal;">Посмотреть весь раздел</a>
		</h2>
		
		
		<xsl:if test="popular/section_popular">
			<div>
				<p style="margin-bottom: 20px; font-size: 16px; font-weight: bold;">Популярные категории</p>
				<xsl:variable name="pcount" select="count(popular/section_popular)"/>
				<ul class="item">
					<xsl:variable name="sec_first" select="//desc_section[name = current()/popular/section_popular[position() mod 3 = 1]/name]"/>
					<xsl:apply-templates select="$sec_first" mode="third_index"/>
				</ul>
				<ul class="item">
					<xsl:variable name="sec_second" select="//desc_section[name = current()/popular/section_popular[position() mod 3 = 2]/name]"/>
					<xsl:apply-templates select="$sec_second" mode="third_index"/>
				</ul>
				<ul class="item last">
					<xsl:variable name="sec_third" select="//desc_section[name = current()/popular/section_popular[position() mod 3 = 0]/name]"/>
					<xsl:apply-templates select="$sec_third" mode="third_index"/>
				</ul>
			</div>
			<hr style="color: red; display: block; margin-top: -10px; margin-bottom: 25px;" />
		</xsl:if>
		<xsl:variable name="leaf_second" select="./desc_section[not(desc_section)]"/>
		<xsl:if test="$leaf_second">
			<xsl:call-template name="pseudo_third_index">
				<xsl:with-param name="sections" select="$leaf_second"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:apply-templates select="./desc_section[desc_section]" mode="second_index">
			<xsl:with-param name="offset">
				<xsl:choose>
					<xsl:when test="count($leaf_second) &gt; 10"><xsl:value-of select="ceiling(count($leaf_second) div 10)"/></xsl:when>
					<xsl:when test="count($leaf_second) &lt;= 10">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</div>
	</xsl:template>
	
	<!-- Второй уровень -->
	
	<xsl:template match="desc_section" mode="second_index">
		<xsl:param name="offset"/>
		<xsl:variable name="pos" select="position()"/>
		<ul class="item{' last'[(number($offset) + $pos) mod 3 = 0]}">
			<li class="title"><a href="{show_section}"><xsl:value-of select="name"/></a></li>
			<xsl:apply-templates select="desc_section" mode="third_index"/>
		</ul>
	</xsl:template>

	<!-- Псевдотретий уровень с разделением -->
	
	<xsl:template name="pseudo_third_index">
		<xsl:param name="sections"/>
		<xsl:param name="position" select="1"/>
		<xsl:choose>
			<xsl:when test="count($sections) &gt; 10">
				<xsl:call-template name="pseudo_third_index">
					<xsl:with-param name="sections" select="$sections[position() &lt;= 10]"/>
					<xsl:with-param name="position" select="$position"/>
				</xsl:call-template>
				<xsl:call-template name="pseudo_third_index">
					<xsl:with-param name="sections" select="$sections[position() &gt; 10]"/>
					<xsl:with-param name="position" select="$position + 1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<ul class="item{' last'[$position mod 3 = 0]}">
					<xsl:apply-templates select="$sections" mode="third_index"/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Третий уровень -->
	
	<xsl:template match="desc_section" mode="third_index">
		<li style="position: relative">
			<xsl:if test="short != '' or pic != ''">
			<a class="fancy" style="background: url('{if (pic and pic != '') then concat(@path, pic) else 'images/icon_question_small.png'}') left top no-repeat; min-height:30px;">
				<xsl:if test="short != ''">
					<xsl:attribute name="href">#about_<xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>
				?
			</a>
			</xsl:if>
			<a href="{show_section}" class="link" style="padding-left: 30px;"><xsl:value-of select="name"/></a>
		</li>
	</xsl:template>


	
	<!-- ****************************    СТРАНИЦА    ******************************** -->

	<xsl:template name="WINSHOP_LINK">
	<div class="callback opt" id="ws1">
		<a class="download" href="{page/catalog/get_winshop}" download="{page/catalog/get_winshop}" onclick="$('#ws1').hide(); $('#ws2').show()"><span>Скачать каталог</span></a>
		<p class="small">для WinShop</p>
	</div>
	<div class="callback opt" id="ws2" style="display: none">
		<p>Архив формируется</p>
	</div>
	</xsl:template>

	<xsl:template match="/">
	<xsl:call-template name="DOCTYPE"/>
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><xsl:call-template name="TITLE"/></title><!-- !!!!!!!!!!!!!!!!!     TODO LOCAL     !!!!!!!!!!!!!!!!!! -->
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<!-- <meta name="robots" content="noindex,nofollow" /> -->
		<meta name="google-site-verification" content="ILyMqxnP7wlfg2pbcwm8S5y1h7vFe71egL2HyuLv3H4" />
		<meta name="yandex-verification" content="47bde087f8dd60b5" />
		<xsl:if test="$keywords != '' or //seo_opt/keywords != ''">
			<meta name="keywords" content="{$keywords}" />
		</xsl:if>
		<xsl:if test="//seo_opt[1]/description != ''">
			<meta name="description" content="{$dsec/prefix_d_opt} {//seo_opt[1]/description} {$dsec/postfix_d_opt}" />
		</xsl:if>
		<xsl:if test="not(//seo_opt[1]/description != '')">
			<meta name="description" content="{$meta_description}" />
		</xsl:if>
		<base href="{page/base}"/>
		<link href="css/main.css" rel="stylesheet" type="text/css"/>
		<link href="css/popup.css" rel="stylesheet" type="text/css"/>
		<link href="css/custom.css" rel="stylesheet" type="text/css"/>
		<link rel="stylesheet" type="text/css" href="fancybox/jquery.fancybox.css" />
		<link rel="stylesheet" type="text/css" href="css/jquery.mCustomScrollbar.css" />
		<link href="nivo-slider/nivo-slider.css" rel="stylesheet" type="text/css"/>
		<link href="nivo-slider/themes/default/default.css" rel="stylesheet" type="text/css"/>
		<link href="js/fotorama/fotorama.css" rel="stylesheet" type="text/css"/>
		<link href="js/jquery-ui.min.css" rel="stylesheet" type="text/css"/>
		<link href="user_files/scripts/anythingSlider/anythingslider.css" rel="stylesheet"/>
		<link href="user_files/scripts/simplelightbox.min.css" rel="stylesheet"/>
		<link href="user_files/scripts/demo.css" rel="stylesheet"/>
		<script src="js/jquery-1.9.1.js"/>
		<script src="js/jquery-ui.min.js"/>
		<script type="text/javascript" src="js/regional-ru.js"></script>
		<script src="js/jquery.mousewheel-3.0.4.pack.js"/>
		<script type="text/javascript" src="js/jquery.menu-aim.js"></script>
		<script type="text/javascript" src="js/fotorama/fotorama.js"></script>
		<script type="text/javascript" src="js/myjs.js"></script>
		<script src="js/jssor.slider.mini.js" type="text/javascript"></script>
<!-- 		<script src="http://api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript"></script> -->

		<xsl:text disable-output-escaping="yes">
		&lt;!--[if lte IE 8]&gt;
		&lt;link href="css/ie8.css" rel="stylesheet" type="text/css"/&gt;
		&lt;![endif]--&gt;
		&lt;!--[if lte IE 7]&gt;
		&lt;link href="css/ie7.css" rel="stylesheet" type="text/css"&gt;
		&lt;![endif]--&gt;
		</xsl:text>
		<script type="text/javascript" src="js/jquery.mCustomScrollbar.js"></script>
		<!-- <script type="text/javascript" src="js/masonry.js"></script> -->
		<script type="text/javascript" src="js/tools.js"></script>
		<script type="text/javascript" src="js/jquery.form.min.js"></script>
		<script type="text/javascript" src="js/ajax.js"></script>
		<script type="text/javascript" src="js/block_revotes.js"></script>
		<script type="text/javascript" src="fancybox/jquery.fancybox.js"></script>
		<script type="text/javascript">
			$(document).ready(function() {
				$(".fancybox, .fancy").fancybox({
					padding : 7
				});
				$('.fancybox.video').fancybox({padding:10, type: 'iframe'});
				$.datepicker.setDefaults($.datepicker.regional["ru"]);
				$(".datepicker").datepicker();
			});
			(function($){
				$(window).load(function(){
					$(".mcsb").mCustomScrollbar({
						advanced:{
	                    	updateOnContentResize: true
	                    }
					});
				});
			})(jQuery)
		</script>
		
		
		<xsl:apply-templates select="/page/named_codes/named_code[place = 'head']"/>
		
	</head>
	<!-- end head -->
	<body>
	
	<xsl:apply-templates select="/page/named_codes/named_code[place = 'body-start']"/>
	
	<div class="mainwrap">
        <div class="content">
			<div class="header">
				<div class="header-line-wrapper">
				<div class="header-line">
					<xsl:if test="$is_registered">
						<xsl:call-template name="PERSONAL_PLACEHOLDER"/>
						<xsl:call-template name="SELLER_BOSS_PLACEHOLDER"/>
					</xsl:if>
					<div class="auth">
					<xsl:if test="$is_registered">
						<div class="orgName" id="orgName">---------</div>
					</xsl:if>
					<xsl:call-template name="LOGIN_PLACEHOLDER"/>
					</div>
				</div>
				<div class="gradient"></div>
				</div>
				<div class="inner">
					<div class="second-line">
						<div class="info-block">
							<div class="rezim-raboti">Режим работы: <strong>ПН-ПТ</strong> c 9.00 по 17.59 | <strong>СБ</strong> c 9.00 по 14.59 | <strong>ВС</strong> - выходной</div>
						</div>
						<div class="price-block">
							<div class="price-date">
								<p class="small-date"><xsl:value-of select="page/catalog/updated"/></p>
							</div>
							<div class="price-choice">
								<div class="price-list">
									<div class="active-price">Выбрать прайс-лист</div>
									<ul id="listprices" style="display:none;">
										<xsl:choose>
										<xsl:when test="page/user/@group = 'registered'">
										<li class="download active" data-href="{page/catalog_menu/@path}{page/catalog_menu/file}" download="{page/catalog_menu/file}">
											<span>Скачать прайс-лист</span></li>
										<li class="download" data-href="{page/catalog_menu/@path}{page/catalog_menu/file_nopic}" download="{page/catalog_menu/file_nopic}">
											<span>Прайс без картинок</span></li>
										<li class="download" data-href="{page/catalog_menu/@path}{page/catalog_menu/roz_pricelist}" download='Пейскурант розничных цен ООО "Надежные инструменты".xls'>
											<span>Прайс-лист с МРЦ</span></li>
										</xsl:when>
										<xsl:otherwise>
											<li class="download active" data-href="{page/catalog_menu/@path}{page/catalog_menu/roz_pricelist}" download='Пейскурант розничных цен ООО "Надежные инструменты".xls'>
											<span>Прайс-лист с МРЦ</span></li>
											<script type="text/javascript">
												$(".active-price").html("Прайс-лист с МРЦ");
											</script>
										</xsl:otherwise>
										</xsl:choose>
									</ul>
								</div>
							</div>
  						<div class="price-accept"><img src="/images/download-ico.png" width="15" height="13" alt="Скачать"/>Скачать</div>
  						</div>
					</div>
					<script type="text/javascript">
						var listP = $("#listprices");
						var priceNameBlock = $(".active-price");
						$(".active-price").on("click", function(){
							listP.slideToggle();
						});

						$("#listprices li").on("click", function(){
							var $that = $(this);
							var priceName = $that.find("span").html();
							$that.parent().find("li").removeClass("active");
							$that.addClass("active");
							priceNameBlock.html(priceName);
							listP.slideToggle();
						});

						$(".price-accept").on("click", function(){
							var ahref = listP.find('.active').data("href");
							window.location = ahref;
						});
					</script>
					<div class="one">
						<a href="{page/index_link}" class="logo" id="logo">
							<img src="images/logo.png" alt="надежный инструмент"/>
						</a>
						<!-- <xsl:call-template name="LOGIN_PLACEHOLDER"/> -->
					</div>
					<div class="two">
						<!-- <xsl:if test="$is_registered">
							<xsl:call-template name="PERSONAL_PLACEHOLDER"/>
							<xsl:call-template name="SELLER_BOSS_PLACEHOLDER"/>
						</xsl:if> -->
						<div class="clear"></div>
						<!--изменения-->
						<!-- 3343-->
						<xsl:call-template name="SEARCH_PLACEHOLDER"/>
					</div>
					<xsl:if test="page/user/@group = 'registered'">
						<div class="three">
							<div style="display:none;">
							<p><a class="download" href="{page/catalog_menu/@path}{page/catalog_menu/file}" download="{page/catalog_menu/file}"><span>Скачать прайс-лист</span></a></p>
							<p>
								<a class="download" href="{page/catalog_menu/@path}{page/catalog_menu/file_nopic}" download="{page/catalog_menu/file_nopic}">
								<span>Прайс без картинок</span></a>
							</p>
							<p>
								<a class="download" href="{page/catalog_menu/@path}{page/catalog_menu/roz_pricelist}" download='Пейскурант розничных цен ООО "Надежные инструменты".xls'>
								<span>Прайс розничный</span></a>
							</p>
							</div>
							<xsl:call-template name="CART_PLACEHOLDER"/>
						</div>
					</xsl:if>
					<xsl:if test="page/user/@group != 'registered'">
						<div class="three">
							<div style="display:none;">
							<div style="height:10px;"></div>
							<p>
								<a class="download" href="{page/catalog_menu/@path}{page/catalog_menu/roz_pricelist}" download="{page/catalog_menu/roz_pricelist}">
								<span>Прайс розничный</span></a>
							</p>
							<p class="small-date"><xsl:value-of select="page/catalog/updated"/></p>
						</div>
						</div>
					</xsl:if>
					<div class="clear"></div>
					<xsl:if test="$is_registered">
						<div id="debt"></div>
					</xsl:if>
					<div class="mainMenu">
						<a class="catalog red" href="#"><span>Каталог продукции</span></a>
						<a href="section/torgovoe_oborudovanie/" class="torg_obor"><span>Стенды и рекламка</span></a>
						<xsl:variable name="reg" select="page/user/@group = 'registered'"/>
						<xsl:apply-templates select="page/menu/text_sections[show = 'все' or show = 'дилеры' or (show = 'авторизованные' and $reg)] | page/menu/news[show = 'все' or show = 'дилеры' or (show = 'авторизованные' and $reg)]"/>
						<a href="sale_only/"><span>Лучшие цены</span></a>
						<xsl:if test="not($is_registered)">
							<div id="reg_link"><a href="{page/register_link}" ><span>Как стать дилером</span></a></div>
						</xsl:if>
						<a href="{page/vote_olny_link}" ><span>Изучение спроса</span></a>
					</div>
					<xsl:call-template name="CATALOG_MENU"/>
				</div>
			</div>
			<div class="pageContent">
				<div class="inner">
					<xsl:call-template name="CONTENT"/>
				</div>
			</div>
			<xsl:if test="$is_registered">
				<div id="check_email"></div>
			</xsl:if>
		</div>
    </div>
	<xsl:if test="page/user/@group = 'registered'">
	<a href="http://opt.nasklade.by/page/prinimaem_predlogeniya_po_tsenoobrazovaniyu_avtorizovannye/" title="Предложите желаемую цену на любой представленный товар!"><div class="sticky-panel">Предложите вашу цену</div></a>
	<div class="sticky-panel-b">
		<div class="yarlik">Проверь себя на демпинг</div>
		<p><a href="http://opt.nasklade.by/page/prover_sebya_na_demping_dilery/" title="Проверить на демпинг">Проверь себя на демпинг</a></p>
		<p><img src="/user_files/img/dif/watching-you.jpg" alt="Проверка на демпинг" width="150" height="126"/></p>
	</div>
	</xsl:if>
    

        <div class="footer">
        <div class="inner">
			<div class="foot-top-block">
				<xsl:if test="$is_registered">
					<xsl:call-template name="WINSHOP_LINK"/>
				</xsl:if>
				<div class="copyr">
					<div class="copy">
						<xsl:value-of select="page/common/copy" disable-output-escaping="yes"/>
					</div>
					<div class="contacts">
						<a href="{page/contacts_link}" ><span>Контакты и реквизиты</span></a>
					</div>
				</div>
			</div>
			<div class="foot-middle-block">
				<div class="f-left-block"><xsl:value-of select="page/common/footer_links" disable-output-escaping="yes"/></div>
				<div class="f-right-block"></div>
			</div>
			<div class="foot-bottom-block">
				<div class="f-left-block">
					<div class="forever">
					Разработка сайта -<br/>
					<a rel="nofollow" href="http://forever.by/">студия веб-дизайна «Forever»</a>
					</div>
				</div>
				<div class="f-right-block">
					<a href="#logo" class="toTop"><span class="up">Наверх</span>↑</a>
				</div>
			</div>
		</div>
    </div>
	
	<!-- Yandex.Metrika counter -->
<script type="text/javascript">
(function (d, w, c) {
    (w[c] = w[c] || []).push(function() {
        try {
            w.yaCounter28237376 = new Ya.Metrika({id:28237376,
                    webvisor:true,
                    clickmap:true,
                    trackLinks:true,
                    accurateTrackBounce:true});
        } catch(e) { }
    });

    var n = d.getElementsByTagName("script")[0],
        s = d.createElement("script"),
        f = function () { n.parentNode.insertBefore(s, n); };
    s.type = "text/javascript";
    s.async = true;
    s.src = (d.location.protocol == "https:" ? "https:" : "http:") + "//mc.yandex.ru/metrika/watch.js";

    if (w.opera == "[object Opera]") {
        d.addEventListener("DOMContentLoaded", f, false);
    } else { f(); }
})(document, window, "yandex_metrika_callbacks");
</script>
<noscript><div><img src="//mc.yandex.ru/watch/28237376" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
<!-- /Yandex.Metrika counter -->
	<xsl:apply-templates select="/page/named_codes/named_code[place = 'body-end']"/>
	</body>
	</html>
	</xsl:template>

	<!-- ****************************    БЛОКИ НА СТРАНИЦЕ    ******************************** -->
	
	<xsl:template match="named_code">
		<xsl:if test="not(disable) or disable = '0' or disable = ''">
			<xsl:value-of select="code" disable-output-escaping="yes"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="content">
	<xsl:value-of select="text" disable-output-escaping="yes"/>
	<xsl:apply-templates select="gallery_part | text_part"/>
	</xsl:template>

	<xsl:template match="text_part">
	<xsl:value-of select="text" disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template match="gallery_part">
	<xsl:value-of select="text" disable-output-escaping="yes"/>
	<div class="fotoramaContainer">
		<div class="fotorama" data-nav="thumbs" data-maxwidth="685" data-maxheight="464" data-allowfullscreen="true">
			<xsl:apply-templates select="picture_pair | video"/>
		</div>
	</div>
	</xsl:template>
	
	<xsl:template match="picture_pair">
	<a href="{@path}{big}"><img src="{@path}{small}" height="65" alt="{name}"/></a>
	</xsl:template>
	
	<xsl:template match="video">
	<a href="{link}" data-img="{@path}{big}"><img src="{@path}{small}" height="65" alt="{name}"/></a>
	</xsl:template>

	<!-- ****************************    Добавление параметра к ссылке    ******************************** -->
	
	<xsl:template match="*" mode="LINK_ADD_VARIABLE_QUERY">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="text"/>
		<xsl:param name="class"/>
		<a class="{$class}" href="{.}{'?'[not(contains(current(), '?'))]}{'&amp;'[contains(current(), '?')]}{$name}={$value}"><xsl:value-of select="$text"/></a>
	</xsl:template>

</xsl:stylesheet>