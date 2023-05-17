*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ORDER.REASON.CONV

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.E.CNV.REL.DESC
*---------------------------------------------------------

* Description :
*----------------------------------------------------------
* Linked With :
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
* Modification History:
* 02-Jun-2010 - HD1021443
* Modification made on referring to gosub WITH.RG.1.299.ONLY section for the ENQUIRY REDO.CUST.RELATION.VINC only
*----------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.USER
$INSERT I_F.EB.LOOKUP
$INSERT I_F.REDO.H.MAIN.COMPANY
$INSERT I_F.REDO.H.REASSIGNMENT


  FN.REDO.H.REASSIGNMENT ='F.REDO.H.REASSIGNMENT'
  F.REDO.H.REASSIGNMENT = ''
  CALL OPF(FN.REDO.H.REASSIGNMENT,F.REDO.H.REASSIGNMENT)
  FN.EB = 'F.EB.LOOKUP'
  F.EB = ''
  CALL OPF(FN.EB,F.EB)


  Y.VAL =  O.DATA
  Y.ACCOUNT =  FIELD(O.DATA,"*",1)
  Y.SERIE = FIELD(O.DATA,"*",2)
  Y.STAUS = FIELD(O.DATA,"*",3)


  Y.LAN = R.USER<EB.USE.LANGUAGE>

  SEL.CMD = " SELECT ":FN.REDO.H.REASSIGNMENT:" WITH ACCOUNT.NUMBER EQ ":Y.ACCOUNT: " AND WITH NEW.SERIES EQ ":Y.SERIE
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOF,ERR)
  Y.ID = SEL.LIST
  CALL F.READ(FN.REDO.H.REASSIGNMENT,Y.ID,R.REDO.H.REASSIGNMENT,F.REDO.H.REASSIGNMENT,ERR)
  Y.DESCRIP = R.REDO.H.REASSIGNMENT<RE.ASS.REASON.FOR.ASSN>
  IF Y.DESCRIP THEN
    Y.VAL = 'L.REASON.ASSING*':Y.DESCRIP
    CALL F.READ(FN.EB,Y.VAL,R.EB,F.EB,Y.ERR.EB)
    O.DATA = R.EB<EB.LU.DESCRIPTION,Y.LAN>
  END ELSE
    O.DATA = 'Apertura'
  END

  RETURN

END
