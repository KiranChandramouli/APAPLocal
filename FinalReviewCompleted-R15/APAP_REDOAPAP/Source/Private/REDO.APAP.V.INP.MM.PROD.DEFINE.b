* @ValidationCode : Mjo2NTI0NDA3MTpDcDEyNTI6MTY4NDgzNjA1MzkzNDpJVFNTOi0xOi0xOjQzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 43
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.V.INP.MM.PROD.DEFINE
*-------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.V.INP.MM.PROD.DEFINE
*-------------------------------------------------------------------------
*Description       : REDO.APAP.V.INP.MM.PROD.DEFINE is a input routine attached to
*                    the VERSION - MM.MONEY.MARKET,APAP.PLACE,the routine checks if
*                    the category entered in the transaction is been listed in the template
*                    REDO.APAP.H.PRODUCT.DEFINE,if not then throw an error
*Linked With       :
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.APAP.H.PRODUCT.DEFINE
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 29 Sep 2010        Mudassir V         2000 ODR-2010-07-0077        Initial Creation
* Date                  who                   Reference              
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.REDO.APAP.H.PRODUCT.DEFINE
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.REDO.APAP.H.PRODUCT.DEFINE = 'F.REDO.APAP.H.PRODUCT.DEFINE'
    F.REDO.APAP.H.PRODUCT.DEFINE  = ''
    CALL OPF(FN.REDO.APAP.H.PRODUCT.DEFINE, F.REDO.APAP.H.PRODUCT.DEFINE)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    GOSUB CHECK.ACCURE.METHOD
    IF Y.FLAG THEN
        RETURN
    END

    GOSUB CHECK.PROD.DEFINITION
    IF ETEXT THEN
        RETURN
    END

    GOSUB LOCATE.CATEGORY

RETURN
*--------------------------------------------------------------------------------------------------------
********************
CHECK.ACCURE.METHOD:
********************
    GOSUB FIND.MULTI.LOCAL.REF

    IF R.NEW(MM.LOCAL.REF)<1,LOC.L.MM.ACCRUE.MET.POS> NE 'EFFECTIVE RATE' THEN
        Y.FLAG = 1
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
CHECK.PROD.DEFINITION:
**********************
    REDO.APAP.H.PRODUCT.DEFINE.ID = 'SYSTEM'
    R.REDO.APAP.H.PRODUCT.DEFINE  = ''
    REDO.APAP.H.PRODUCT.DEFINE.ER = ''

*  CALL F.READ(FN.REDO.APAP.H.PRODUCT.DEFINE,REDO.APAP.H.PRODUCT.DEFINE.ID,R.REDO.APAP.H.PRODUCT.DEFINE,F.REDO.APAP.H.PRODUCT.DEFINE,REDO.APAP.H.PRODUCT.DEFINE.ER) ;*Tus Start
    CALL CACHE.READ(FN.REDO.APAP.H.PRODUCT.DEFINE,REDO.APAP.H.PRODUCT.DEFINE.ID,R.REDO.APAP.H.PRODUCT.DEFINE,REDO.APAP.H.PRODUCT.DEFINE.ER) ; * Tus End

    IF NOT(R.REDO.APAP.H.PRODUCT.DEFINE) THEN
        AF     = MM.CATEGORY
        ETEXT  = 'EB-NO.PROD.DEFINE'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
****************
LOCATE.CATEGORY:
****************
    LOCATE R.NEW(MM.CATEGORY) IN R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.CATEGORY,1> SETTING Y.CAT.POS ELSE
        AF    = MM.CATEGORY
        ETEXT = 'EB-PROD.NOT.ALLOW'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY   = 'MM.MONEY.MARKET'
    FLD.ARRAY    = 'L.MM.ACCRUE.MET'
    FLD.POS      = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.MM.ACCRUE.MET.POS  = FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END
