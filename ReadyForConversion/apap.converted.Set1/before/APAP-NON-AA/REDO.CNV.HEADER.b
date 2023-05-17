*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CNV.HEADER
*------------------------------------------------------------------------------------------------------
*DESCRIPTION
* conversion routine to return the value to be displayed in header

*------------------------------------------------------------------------------------------------------
*APPLICATION
* ENQUIRY REDO.DEBIT.CARD.ACTIVE.ENQ
*-------------------------------------------------------------------------------------------------------

*
* Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Temenos Application Management
* PROGRAM NAME : REDO.CNV.HEADER
*----------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO         REFERENCE         DESCRIPTION
*16.03.2011      Janani     ODR-2010-03-0153  INITIAL CREATION
*
*----------------------------------------------------------------

$INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_ENQUIRY.COMMON
  GOSUB INIT
  GOSUB PROCESS
  RETURN

*------------------------------------------------------------
INIT:
*------------------------------------------------------------
  CHANGE "|" TO FM IN O.DATA
  ACTIVE.DATE = FIELD(O.DATA,FM,1)
  AUTHORISER = FIELD(O.DATA,FM,2)
  CARD.TYPE = FIELD(O.DATA,FM,3)
  ACTIVE = FIELD(O.DATA,FM,4)
  RETURN

*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

  IF ACTIVE.DATE THEN

    Y.SEL = "FECHA DE ":ACTIVE:" DESDE: "
    Y.SEL := OCONV(ICONV(FIELD(ACTIVE.DATE," ",1),"D4"),"D4")
    Y.SEL := " ,FECHA DE ":ACTIVE:" HASTA: "
    Y.SEL := OCONV(ICONV(FIELD(ACTIVE.DATE," ",2),"D4"),"D4")
  END
  IF AUTHORISER THEN
    IF Y.SEL THEN
      Y.SEL := ", USUARIO: ":AUTHORISER
    END ELSE
      Y.SEL = "USUARIO: ":AUTHORISER
    END
  END
  IF CARD.TYPE THEN
    IF Y.SEL THEN
      Y.SEL := ", PRODUCTO: ":CARD.TYPE
    END ELSE
      Y.SEL = "PRODUCTO: ":CARD.TYPE
    END
  END
  IF Y.SEL THEN
    O.DATA = Y.SEL
  END ELSE
    O.DATA = "ALL"
  END

  RETURN
*--------------
END
