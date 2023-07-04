* @ValidationCode : MjoxMjIzNzUyMzMyOkNwMTI1MjoxNjgxMzc2MDk4ODUzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 14:24:58
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
*
* Date             Who                   Reference      Description
* 13.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 13.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
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
