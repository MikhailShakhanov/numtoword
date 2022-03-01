<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"
	            omit-xml-declaration="no"/>
	<xsl:template name="num-to-word">
		<xsl:param name="value"/>
		<xsl:param name="sex"
		           select="'m'"/>
		<xsl:variable name="power"
		              select="0"/>
		
    <xsl:variable name="minus">
			<xsl:choose>
				<xsl:when test="0 > number(translate($value,',','.'))"> 
						<xsl:value-of select="'минус '"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
    <xsl:value-of select="$minus"/>

		<xsl:variable name="value2">
			<xsl:value-of select="abs(number(translate($value,',','.')))"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="floor(number($value2)) > 0">
				<xsl:call-template name="float2speech">
					<xsl:with-param name="value"
					                select="floor(number($value2))"/>
					<xsl:with-param name="sex"
					                select="'m'"/>
					<xsl:with-param name="power"
					                select="0"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'ноль '"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:variable name="intpart">
			<xsl:value-of select="floor(number($value2))"/>
		</xsl:variable>
		<xsl:variable name="fractpart">
			<xsl:value-of select="round((number($value2)-floor(number($value2)))*100)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$intpart mod 10=1">
				<xsl:value-of select="'рубль '"/>
			</xsl:when>
			<xsl:when test="$intpart mod 10=2 or $intpart mod 10=3 or $intpart mod 10=4">
				<xsl:value-of select="'рубля '"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'рублей '"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="floor(number($value2))!=$value2">
				<xsl:variable name="kop"
				              select="round((number($value2)-floor(number($value2)))*100)"/>
				<xsl:call-template name="float2speech">
					<xsl:with-param name="value"
					                select="$kop"/>
					<xsl:with-param name="sex"
					                select="'f'"/>
					<xsl:with-param name="power"
					                select="0"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'ноль '"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="$fractpart mod 10=1">
				<xsl:value-of select="'копейка '"/>
			</xsl:when>
			<xsl:when test="$fractpart mod 10=2 or $fractpart mod 10=3 or $fractpart mod 10=4">
				<xsl:value-of select="'копейки '"/>
			</xsl:when>
			<!--<xsl:when test="$fractpart = 0">
				<xsl:value-of select="''"/>
			</xsl:when>-->
			<xsl:otherwise>
				<xsl:value-of select="'копеек '"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="float2speech">
		<xsl:param name="value"/>
		<xsl:param name="sex"/>
		<xsl:param name="power"/>
		<xsl:variable name="ret"
		              select="' '"/>
		<xsl:variable name="pp">
			<xsl:choose>
				<xsl:when test="$power!=0">
					<xsl:if test="$power=1">
						<xsl:value-of select="'f'"/>
					</xsl:if>
					<xsl:if test="$power!=1">
						<xsl:value-of select="'m'"/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$sex"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="strx">
			<xsl:if test="$power!=0">
				<xsl:variable name="p">
					<xsl:choose>
						<xsl:when test="$power!=0">
							<xsl:if test="$power=1">
								<xsl:value-of select="'f'"/>
							</xsl:if>
							<xsl:if test="$power!=1">
								<xsl:value-of select="'m'"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$sex"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="i"
				              select="floor(number($value))"/>
				<xsl:variable name="x"
				              select="floor(($i mod 100) div 10)"/>
				<xsl:variable name="z">
					<xsl:choose>
						<xsl:when test="$x=1">
							<xsl:number value="5"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$i mod 10"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="ret2">
					<xsl:choose>
						<xsl:when test="$z=1">
							<xsl:if test="$p='m'">
								<xsl:value-of select="concat(' ',$ret)"/>
							</xsl:if>
							<xsl:if test="$p='f'">
								<xsl:value-of select="concat('а ',$ret)"/>
							</xsl:if>
						</xsl:when>
						<xsl:when test="$z > 1 and 5 > $z">
							<xsl:if test="$p='m'">
								<xsl:value-of select="concat('а ',$ret)"/>
							</xsl:if>
							<xsl:if test="$p='f'">
								<xsl:value-of select="concat('и ',$ret)"/>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="$p='m'">
								<xsl:value-of select="concat('ов ',$ret)"/>
							</xsl:if>
							<xsl:if test="$p='f'">
								<xsl:value-of select="concat(' ',$ret)"/>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="($value mod 1000)=0">
						<xsl:value-of select="' '"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$power=1">
								<xsl:value-of select="concat('тысяч',$ret2)"/>
							</xsl:when>
							<xsl:when test="$power=2">
								<xsl:value-of select="concat('миллион',$ret2)"/>
							</xsl:when>
							<xsl:when test="$power=3">
								<xsl:value-of select="concat('миллиард',$ret2)"/>
							</xsl:when>
							<xsl:when test="$power=4">
								<xsl:value-of select="concat('триллион',$ret2)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="str">
			<xsl:if test="$value > 999">
				<xsl:variable name="vd1"
				              select="floor($value div 1000)"/>
				<xsl:variable name="str">
					<xsl:call-template name="float2speech">
						<xsl:with-param name="value"
						                select="$vd1"/>
						<xsl:with-param name="sex"
						                select="$pp"/>
						<xsl:with-param name="power"
						                select="$power+1"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$str"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="ppp">
			<xsl:choose>
				<xsl:when test="$pp!=''">
					<xsl:value-of select="$pp"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'m'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="str2">
			<xsl:call-template name="int2speech">
				<xsl:with-param name="dig"
				                select="number(substring(format-number($value,'#########'),string-length(format-number($value,'#########'))-2,3))"/>
				<xsl:with-param name="sex"
				                select="$ppp"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:text> </xsl:text>
		<xsl:value-of select="concat(concat(translate(substring((normalize-space($str)),1,1),'абвгдежзиклмнопрстуфхцчшщъыьэюя','АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'),substring(normalize-space($str),2,string-length($str))),' ')"/>
		<xsl:value-of select="$str2"/>
		<xsl:value-of select="$strx"/>
	</xsl:template>
	<xsl:template name="int2speech">
		<xsl:param name="dig"/>
		<xsl:param name="sex"/>
		<xsl:variable name="remainder"
		              select="floor(($dig mod 1000) div 100)"/>
		<xsl:variable name="ret">
			<xsl:choose>
				<xsl:when test="$remainder=1">
					<xsl:value-of select="'сто '"/>
				</xsl:when>
				<xsl:when test="$remainder=2">
					<xsl:value-of select="'двести '"/>
				</xsl:when>
				<xsl:when test="$remainder=3">
					<xsl:value-of select="'триста '"/>
				</xsl:when>
				<xsl:when test="$remainder=4">
					<xsl:value-of select="'четыреста '"/>
				</xsl:when>
				<xsl:when test="$remainder=5">
					<xsl:value-of select="'пятьсот '"/>
				</xsl:when>
				<xsl:when test="$remainder=6">
					<xsl:value-of select="'шестьсот '"/>
				</xsl:when>
				<xsl:when test="$remainder=7">
					<xsl:value-of select="'семьсот '"/>
				</xsl:when>
				<xsl:when test="$remainder=8">
					<xsl:value-of select="'восемьсот '"/>
				</xsl:when>
				<xsl:when test="$remainder=9">
					<xsl:value-of select="'девятьсот '"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="remainder2"
		              select="floor(($dig mod 100) div 10)"/>
		<xsl:variable name="remainder3"
		              select="floor($dig mod 10)"/>
		<xsl:variable name="ret2">
			<xsl:choose>
				<xsl:when test="$remainder2=1">
					<xsl:choose>
						<xsl:when test="$remainder3=0">
							<xsl:value-of select="'десять '"/>
						</xsl:when>
						<xsl:when test="$remainder3=1">
							<xsl:value-of select="'одиннадцать '"/>
						</xsl:when>
						<xsl:when test="$remainder3=2">
							<xsl:value-of select="'двенадцать '"/>
						</xsl:when>
						<xsl:when test="$remainder3=3">
							<xsl:value-of select="'тринадцать '"/>
						</xsl:when>
						<xsl:when test="$remainder3=4">
							<xsl:value-of select="'четырнадцать '"/>
						</xsl:when>
						<xsl:when test="$remainder3=5">
							<xsl:value-of select="'пятнадцать '"/>
						</xsl:when>
						<xsl:when test="$remainder3=6">
							<xsl:value-of select="'шестнадцать '"/>
						</xsl:when>
						<xsl:when test="$remainder3=7">
							<xsl:value-of select="'семнадцать '"/>
						</xsl:when>
						<xsl:when test="$remainder3=8">
							<xsl:value-of select="'восемнадцать '"/>
						</xsl:when>
						<xsl:when test="$remainder3=9">
							<xsl:value-of select="'девятнадцать '"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$remainder2=2">
					<xsl:value-of select="'двадцать '"/>
				</xsl:when>
				<xsl:when test="$remainder2=3">
					<xsl:value-of select="'тридцать '"/>
				</xsl:when>
				<xsl:when test="$remainder2=4">
					<xsl:value-of select="'сорок '"/>
				</xsl:when>
				<xsl:when test="$remainder2=5">
					<xsl:value-of select="'пятьдесят '"/>
				</xsl:when>
				<xsl:when test="$remainder2=6">
					<xsl:value-of select="'шестьдесят '"/>
				</xsl:when>
				<xsl:when test="$remainder2=7">
					<xsl:value-of select="'семьдесят '"/>
				</xsl:when>
				<xsl:when test="$remainder2=8">
					<xsl:value-of select="'восемьдесят '"/>
				</xsl:when>
				<xsl:when test="$remainder2=9">
					<xsl:value-of select="'девяносто '"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ret3">
			<xsl:choose>
				<xsl:when test="$remainder2!=1">
					<xsl:choose>
						<xsl:when test="$remainder3=1">
							<xsl:choose>
								<xsl:when test="$sex='f'">
									<xsl:value-of select="'одна '"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'один '"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$remainder3=2">
							<xsl:choose>
								<xsl:when test="$sex='f'">
									<xsl:value-of select="'две '"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'два '"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="$remainder3=3">
							<xsl:value-of select="'три '"/>
						</xsl:when>
						<xsl:when test="$remainder3=4">
							<xsl:value-of select="'четыре '"/>
						</xsl:when>
						<xsl:when test="$remainder3=5">
							<xsl:value-of select="'пять '"/>
						</xsl:when>
						<xsl:when test="$remainder3=6">
							<xsl:value-of select="'шесть '"/>
						</xsl:when>
						<xsl:when test="$remainder3=7">
							<xsl:value-of select="'семь '"/>
						</xsl:when>
						<xsl:when test="$remainder3=8">
							<xsl:value-of select="'восемь '"/>
						</xsl:when>
						<xsl:when test="$remainder3=9">
							<xsl:value-of select="'девять '"/>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($ret,$ret2,$ret3)"/>
	</xsl:template>
	<xsl:template match="/">
		<xsl:call-template name="num-to-word">
			<xsl:with-param name="value"
			                select="translate/amount/node()"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>

