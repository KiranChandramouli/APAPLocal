* @ValidationCode : MjoxNzU4MTA0MzMzOkNwMTI1MjoxNzAwODQyNjcxMTYwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Nov 2023 21:47:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.MATRIX.FILE.SELECTOR
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.LAPAP.AZ.PENAL.RATE
*-----------------------------------------------------------------------------
*Description: Select the correspondign xsl file to display AZ contract pdf.
*Date: October 10, 2023
*This routine was modded from L.APAP.ENQ.ARCHIVO.MATRIZ to use AZ ID
* instead of the category as entry param
* from O.DATA variable, from the AZ we will read the category a creation date.
*********************************************************************************************************
*Modification Details:
*=====================
*  Date              Who                 Reference                  Description
*  24/11/2023        Santosh          R22 Manual Conversion    BP Removed From Inserts, Changed FM/VM/ to @FM/@VM

*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB DO.SELECT

RETURN

INIT:
    Y.ACCOUNT = O.DATA

    FN.LAPAP.AZ.PENAL.RATE = 'F.ST.LAPAP.AZ.PENAL.RATE'
    F.LAPAP.AZ.PENAL.RATE = ''
    CALL OPF(FN.LAPAP.AZ.PENAL.RATE,F.LAPAP.AZ.PENAL.RATE)

    FN.AZ.ACC = 'F.AZ.ACCOUNT'
    F.AZ.ACC = ''
    CALL OPF(FN.AZ.ACC,F.AZ.ACC)

    Y.ARCHIVO.MATRIZ = ""

RETURN

DO.SELECT:
    CALL F.READ(FN.AZ.ACC,Y.ACCOUNT,R.AZ.ACC,F.AZ.ACC,Y.AZ.ERR)

    IF (R.AZ.ACC) THEN
        Y.CATEGORY = R.AZ.ACC<AZ.CATEGORY>
        Y.CREATE.DATE = R.AZ.ACC<AZ.CREATE.DATE>

        GOSUB DO.READ.PARA

        BEGIN CASE
*            CASE Y.CATEGORY = 6612
            CASE Y.CATEGORY EQ 6612;* R22 UTILITY AUTO CONVERSION

                Y.ARCHIVO.MATRIZ = "PAGE=CER.FINANCIERO.LIBRE.xsl"

*            CASE Y.CATEGORY = 6613
            CASE Y.CATEGORY EQ 6613;* R22 UTILITY AUTO CONVERSION
                Y.ARCHIVO.MATRIZ = "PAGE=CER.FINANCIERO.LIBRE.xsl"
*            CASE Y.CATEGORY = 6614
            CASE Y.CATEGORY EQ 6614;* R22 UTILITY AUTO CONVERSION
                IF Y.CREATE.DATE GE Y.REF.DATE THEN
                    Y.ARCHIVO.MATRIZ = "PAGE=CER.FIN.SIN.REDENCION_NVO.xsl"
                END ELSE
                    Y.ARCHIVO.MATRIZ = "PAGE=CER.FINANCIERO.SIN.REDENCION.xsl"
                END
*            CASE Y.CATEGORY = 6615
            CASE Y.CATEGORY EQ 6615;* R22 UTILITY AUTO CONVERSION
                IF Y.CREATE.DATE GE Y.REF.DATE THEN
                    Y.ARCHIVO.MATRIZ = "PAGE=CER.FIN.SIN.REDENCION_NVO.xsl"
                END ELSE
                    Y.ARCHIVO.MATRIZ = "PAGE=CER.FINANCIERO.SIN.REDENCION.xsl"
                END
            CASE 1
                IF Y.CREATE.DATE GE Y.REF.DATE THEN
                    Y.ARCHIVO.MATRIZ = "PAGE=CER.FIN.FINANCIERO_NVO.xsl"
                END ELSE
                    Y.ARCHIVO.MATRIZ = "PAGE=CER.FINANCIERO.FINANCIERO.xsl"
                END
        END CASE

        O.DATA = Y.ARCHIVO.MATRIZ

    END

RETURN

DO.READ.PARA:
    CALL F.READ(FN.LAPAP.AZ.PENAL.RATE,Y.CATEGORY,R.LAPAP.AZ.PENAL.RATE,F.LAPAP.AZ.PENAL.RATE,Y.AZ.P.ERR)
    IF (R.LAPAP.AZ.PENAL.RATE) THEN
        Y.REF.DATE = R.LAPAP.AZ.PENAL.RATE<ST.LAP50.FROM.DATE>
    END

RETURN

END
