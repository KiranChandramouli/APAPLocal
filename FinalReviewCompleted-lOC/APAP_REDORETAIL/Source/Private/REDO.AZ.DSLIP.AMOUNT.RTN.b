* @ValidationCode : Mjo5NDExNjAxMjQ6Q3AxMjUyOjE2ODEyODM5NDIwMTA6SVRTUzotMTotMTotNjoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:49:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -6
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*----------------------------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE REDO.AZ.DSLIP.AMOUNT.RTN(Y.AMT)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Arulprakasam P
* PROGRAM NAME: REDO.DS.SECURITY.TERM
* ODR NO      : ODR-2010-07-0082
*----------------------------------------------------------------------
*DESCRIPTION: This routine is attched in DEAL.SLIP.FORMAT 'REDO.BUS.SELL'
* to get the details of the Product selected for LETTER

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE               WHO           REFERENCE             DESCRIPTION
* NA             Arulprakasam P   ODR-2010-07-0082      Initital Draft
* 28 May 2011    H Ganesh         PACS00023978 - B.29   Modified for the issue
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CURRENCY

    GOSUB PROCESS
RETURN

PROCESS:
********

    Y.FULL.AMT=R.NEW(AZ.PRINCIPAL)
    Y.CUR=R.NEW(AZ.CURRENCY)

    CALL CACHE.READ('F.CURRENCY',Y.CUR,R.CUR,CUR.ERR)
    IN.AMT=FIELD(Y.FULL.AMT,'.',1)
    Y.DECIMAL=FIELD(Y.FULL.AMT,'.',2)
    Y.DEC.OUT=''
    IF Y.DECIMAL NE 0 THEN
        Y.DEC.OUT=' CON ':Y.DECIMAL:'/100'
    END
    OUT.AMT=''
    LANGUAGE='ES'
    LINE.LENGTH=100
    NO.OF.LINES=1
    ERR.MSG=''
    CALL DE.O.PRINT.WORDS(IN.AMT,OUT.AMT,LANGUAGE,LINE.LENGTH,NO.OF.LINES,ERR.MSG)
    CHANGE '*' TO ' ' IN OUT.AMT
    OUT.AMT = TRIMBS(OUT.AMT)
    IN.AMT=FMT(IN.AMT,"R2, #15")
    Y.AMT.IN.WORDS='(':OUT.AMT:' ':R.CUR<EB.CUR.CCY.NAME>:Y.DEC.OUT:')'
    Y.TOTAL.LEN=LEN(Y.AMT.IN.WORDS)
    IF Y.TOTAL.LEN GT 45 THEN
        Y.AMT.IN.WORDS= Y.AMT.IN.WORDS[1,35]:@VM:'         ':Y.AMT.IN.WORDS[36,Y.TOTAL.LEN]
    END

    Y.AMT=Y.CUR:' ':TRIMB(FMT(Y.FULL.AMT,'L2,#19')):Y.AMT.IN.WORDS

RETURN

END
