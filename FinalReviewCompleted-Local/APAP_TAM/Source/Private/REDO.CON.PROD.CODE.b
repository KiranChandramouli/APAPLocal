* @ValidationCode : MjotOTM1OTI3MDExOkNwMTI1MjoxNjgwNjc5MTk5NDQ0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:49:59
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
SUBROUTINE REDO.CON.PROD.CODE
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEEVA T
* PROGRAM NAME: REDO.CON.PROD.CODE
* ODR NO : ODR-2010-03-0400
*----------------------------------------------------------------------
*DESCRIPTION: This routine is conversion rotuine
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*10 JUN 2011 KAVITHA PACS00063138 FIX for PACS00063138
** 05-04-2023 R22 Auto Conversion no changes
** 05-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.REDO.STOCK.QTY.COUNT
    $INSERT I_F.REDO.CARD.SERIES.PARAM


    FN.CARD.TYPE ='F.CARD.TYPE'
    F.CARD.TYPE =''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
    CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)


    LREF.APP = 'CARD.TYPE'
    LREF.FIELDS = 'L.CT.SUMIN.CO'
    LREF.POS=''
    CALL GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    CARD.POS = LREF.POS<1,1>

    CALL CACHE.READ(FN.REDO.CARD.SERIES.PARAM,'SYSTEM',R.REDO.CARD.SERIES.PARAM,Y.ERR)
    LOCATE "-" IN O.DATA SETTING POS THEN
        Y.PROD.CODE = FIELD(O.DATA,"-",2)
        LOCATE Y.PROD.CODE IN R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES,1> SETTING POS THEN
            Y.TYPE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE,POS>
        END
    END ELSE
        Y.TYPE = O.DATA
    END
    CALL F.READ(FN.CARD.TYPE,Y.TYPE,R.CARD.TYPE,F.CARD.TYPE,Y.EC)
    O.DATA = R.CARD.TYPE<CARD.TYPE.LOCAL.REF,CARD.POS>

RETURN
END
