* @ValidationCode : MjotOTE0Njk0MzA1OkNwMTI1MjoxNjg0ODM2MDM1MDQyOklUU1M6LTE6LTE6MTk3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 197
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CLEAR.PARAM.VALIDATE
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.APAP.CLEAR.PARAM.VALIDATE
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*            This validation routine to the REDO.APAP.CLEAR.PARAM tempalte
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 30-AUG-2011     KAVITHA       PACS00112979      Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   F.READ to CACHE.READ , $INCLUDET24.BP into $INSERT
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_F.REDO.APAP.CLEAR.PARAM



    FN.FT.COM.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COM.TYPE=''
    CALL OPF(FN.FT.COM.TYPE,F.FT.COM.TYPE)

    FN.FT.CHARGE.TYPE='F.FT.CHARGE.TYPE'
    F.FT.CHARGE.TYPE=''
    CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)


    GET.FT.REF.CHG.LIST = R.NEW(CLEAR.PARAM.FT.REF.CHG)
    CHANGE @VM TO @FM IN GET.FT.REF.CHG.LIST
    TOT.VALUE = DCOUNT(GET.FT.REF.CHG.LIST,@FM)

    R.FT.COM.TYPE = ''
    R.FT.CHARGE.TYPE = ''


    LOOP.CNTR = 1

    LOOP
    WHILE LOOP.CNTR LE TOT.VALUE

        GET.FT.REF.CHG = GET.FT.REF.CHG.LIST<LOOP.CNTR>
        CALL CACHE.READ(FN.FT.COM.TYPE, GET.FT.REF.CHG, R.FT.COM.TYPE, FCT.ERR) ;*R22 AUTO CODE CONVERSION
        IF NOT(R.FT.COM.TYPE) THEN

            CALL CACHE.READ(FN.FT.CHARGE.TYPE, GET.FT.REF.CHG, R.FT.CHARGE.TYPE, CHG.ERR);*R22 AUTO CODE CONVERSION
            IF NOT(R.FT.CHARGE.TYPE) THEN
                AF = CLEAR.PARAM.FT.REF.CHG
                AV = LOOP.CNTR
                ETEXT = 'EB-INVALID.FT.CHG.CODE'
                CALL STORE.END.ERROR
            END
        END

        LOOP.CNTR += 1
    REPEAT

RETURN
*------------------------
END
