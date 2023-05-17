*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE ARC.PDF.TEST(SAMPLE.ID,SAMPLE.RESPONSE,RESPONSE.TYPE,STYLE.SHEET)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.INS.SELECT
*----------------------------------------------------------

* Description   : Routine is used to generate PDF
* Linked with   : PDF for Account statement
* In Parameter  : None
* Out Parameter : None
*----------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                        Reference                    Description
*   ------          ------                      -------------                -------------
* 22-09-2010        Sakthi Sellappillai         ODR-2010-08-0031 B.187       Initial Creation
*-----------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_BALANCE.COMMON

  ENQ.OUTPUT = ''
  RESPONSE.TYPE = 'XML.ENQUIRY'
  STYLE.SHEET = '/transforms/host/hostdetail.xsl'

  LOCATE 'BOOKING.DATE' IN D.FIELDS<1> SETTING Y.BK.DATE.POS THEN
    Y.PERIOD = D.RANGE.AND.VALUE<Y.BK.DATE.POS>
  END

  LOCATE 'ACCOUNT' IN D.FIELDS<1> SETTING Y.AC.POS THEN
    Y.ACCOUNT = D.RANGE.AND.VALUE<Y.AC.POS>
  END

  Y.CUS.NAME = FIELD(Y.HDR,'^^',3,1)
  Y.MSG = "FD1=":Y.CUS.NAME

  Y.DE.ADD = FIELD(Y.HDR,'^^',4,1)
  Y.ADD = FIELD(Y.DE.ADD,'ý',1,1)
  Y.MSG := '^^'
  Y.MSG := 'FD2='
  Y.MSG := '':Y.ADD

  Y.AC.NO = FIELD(Y.HDR,'^^',2,1)
  Y.MSG := '^^'
  Y.MSG := 'FD3='
  Y.MSG := '':Y.AC.NO

  Y.MSG := '^^'
  Y.MSG := 'FD4='
  Y.MSG := '':Y.PERIOD

  Y.CONSULT.DATE = FIELD(Y.HDR,'^^',1,1)
  Y.MSG := '^^'
  Y.MSG := 'FD5='
  Y.MSG := '':Y.CONSULT.DATE

  Y.MSG := '^^'
  Y.MSG := 'FD6='
  Y.MSG := '':Y.FINAL.ARR

  Y.SEP.CNT = DCOUNT(Y.HDR,'^^')
  Y.AMT = FIELD(Y.HDR,'^^',Y.SEP.CNT,1)
  Y.BAL.POS = Y.SEP.CNT -1
  Y.BAL = FIELD(Y.HDR,'^^',Y.BAL.POS,1)
  Y.MSG := '^^'
  Y.MSG := 'FD7='
  Y.MSG := '':Y.BAL

  Y.MSG := '^^'
  Y.MSG := 'FD8='
  Y.MSG := '':

  Y.MSG := '^^'
  Y.MSG := 'FD9='
  Y.MSG := '':TOT.CRE

  Y.MSG := '^^'
  Y.MSG := 'FD10='
  Y.MSG := '':Y.TOT.BALANCE

  Y.MSG := '^^'
  Y.MSG := 'PAGE=poder.xsl'

  XML.RECS = '<window><panes><pane><dataSection><enqResponse>'
  XML.RECS :='<r><c><cap>' : Y.MSG : ' </cap></c></r>'
  XML.RECS :='</enqResponse></dataSection></pane></panes></window>'
  SAMPLE.RESPONSE = XML.RECS
  RETURN
END
