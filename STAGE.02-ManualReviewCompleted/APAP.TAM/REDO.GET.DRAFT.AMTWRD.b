* @ValidationCode : MjoxMzAxODc0MDg6Q3AxMjUyOjE2ODExMDcxMTYyNTc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 11:41:56
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
SUBROUTINE REDO.GET.DRAFT.AMTWRD(Y.AMT)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.AMOUNT.LETTER
* ODR NUMBER    : ODR-2009-10-0795
*-----------------------------------------------------------------------------
* Description   : This routine is used for Deal slip. Will return the amount in letters in spanish
* In parameter  :
* out parameter : Y.AMT
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 14-01-2011     MARIMUTHU S       ODR-2009-10-0795   Initial Creation
* 03-06-2011     Bharath G         PACS00071471       Number to words Conversion Routine changed
* 22/04/2014     Vignesh Kumaar R  PACS00273064       USD Cheque

** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - line no 141
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.PRINT.CHQ.LIST

    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*=======

* PACS00071471 - S

    IF Y.AMT EQ 'CONCEPT' THEN
        Y.CONCEPT = R.NEW(PRINT.CHQ.LIST.CONCEPT)
        Y.CONCEPT = CHANGE(Y.CONCEPT,@FM,' ')
        Y.CONCEPT = CHANGE(Y.CONCEPT,@VM,' ')
        Y.AMT = FMT(Y.CONCEPT,"65L")
    END ELSE

        GOSUB USD.CHEQUE.WORDING
        GOSUB LCY.CHEQUE.WORDING

        IF Y.AMT EQ 'UNO' OR Y.AMT EQ 'ONE' THEN
            IF OUT.AMT.LINE2 THEN
                Y.AMT = UPCASE(OUT.AMT.LINE1)
            END ELSE
                Y.AMT = ''
            END
        END

        IF Y.AMT EQ 'DOS' OR Y.AMT EQ 'TWO' THEN
            IF OUT.AMT.LINE2 THEN
                Y.AMT = UPCASE(OUT.AMT.LINE2)
            END ELSE
                Y.AMT = UPCASE(OUT.AMT.LINE1)
            END
        END
    END

RETURN

*------------------------------------------------------------------------------------------------------------------

LCY.CHEQUE.WORDING:
*-----------------*

    Y.WORD.LENGTH = LEN(OUT.AMT)
    IF Y.WORD.LENGTH GT 84 THEN
        GET.NO.OF.WORDS = COUNT(OUT.AMT,' ')
        Y.AMT.WORD = OUT.AMT
        Y.SPACE = GET.NO.OF.WORDS
        FOR I.VAR = 1 TO GET.NO.OF.WORDS STEP 1 ;* R22 Auto conversion
            Y.SPACE -= 1 ;* R22 Auto conversion
            Y.AMT.SPANISH = INDEX(OUT.AMT,' ',Y.SPACE)
            Y.LEAVE.SPACE = '    '
            IF Y.AMT.SPANISH LE 84 THEN
                LF = CHARX(10) ;* R22 Auto conversion
                Y.LAST.WORD = Y.WORD.LENGTH - Y.AMT.SPANISH
*                    OUT.AMT = OUT.AMT[1,Y.AMT.SPANISH]:LF:Y.LEAVE.SPACE:OUT.AMT[Y.AMT.SPANISH+1,Y.LAST.WORD]
                OUT.AMT.LINE1 = OUT.AMT[1,Y.AMT.SPANISH]
*                    OUT.AMT.LINE2 = Y.LEAVE.SPACE:OUT.AMT[Y.AMT.SPANISH+1,Y.LAST.WORD]
                OUT.AMT.LINE2 = OUT.AMT[Y.AMT.SPANISH+1,Y.LAST.WORD]
                BREAK
            END
        NEXT I.VAR ;* R22 Auto conversion
    END ELSE
        OUT.AMT.LINE1 = OUT.AMT
    END
*        Y.AMT = UPCASE(OUT.AMT)

RETURN

USD.CHEQUE.WORDING:
*-----------------*

* Fix for PACS00273064 [USD Cheque]

    IF Y.AMT EQ 'ONE' OR Y.AMT EQ 'TWO' THEN

        IN.AMT = R.NEW(PRINT.CHQ.LIST.AMOUNT)
        BFR.DEC = FIELD(IN.AMT,'.',1)
        AFT.DEC = FIELD(IN.AMT,'.',2)

        OUT.AMT = '' ; LG.CODE = 'GB' ; LENGTH = '' ; ER = ''
        CALL DE.O.PRINT.WORDS(BFR.DEC,OUT.AMT,LG.CODE,LENGTH,1,ER)
        OUT.AMT = CHANGE(OUT.AMT,'*',' ')
        FINAL.AMT = OUT.AMT

        IF AFT.DEC NE '' THEN

            OUT.AMT = '' ; LG.CODE = 'GB' ; LENGTH = '' ; ER = ''
            CALL DE.O.PRINT.WORDS(AFT.DEC,OUT.AMT,LG.CODE,LENGTH,1,ER)
            OUT.AMT = CHANGE(OUT.AMT,'*',' ')
            IF OUT.AMT EQ '' THEN
                FINAL.AMT := 'DOLLARS ZERO CENTS'
            END ELSE
                FINAL.AMT := 'DOLLARS ':OUT.AMT:'CENTS'
            END
            OUT.AMT = FINAL.AMT
        END

* End of Fix

    END ELSE
        IN.AMT = 'CHQ':R.NEW(PRINT.CHQ.LIST.AMOUNT)
        CALL APAP.TAM.REDO.CONVERT.NUM.TO.WORDS(IN.AMT, OUT.AMT, LINE.LENGTH, NO.OF.LINES, ERR.MSG) ;* R22 Manual Conversion

        OUT.AMT = CHANGE(OUT.AMT,@VM,' ')
        OUT.AMT = CHANGE(OUT.AMT,'  ',' ')
        OUT.AMT = CHANGE(OUT.AMT,'*','')
*            OUT.AMT = CHANGE(OUT.AMT,'pesos ','')
    END

RETURN

*-----------------------------------------------------------------------------
END
