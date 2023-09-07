* @ValidationCode : Mjo1MjU1NDQ4MzI6Q3AxMjUyOjE2ODQ0OTEwNDcxNjg6SVRTUzotMTotMToxMzY6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 136
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.V.VAL.REA.COLLATERAL
*
* ====================================================================================
*
*    - Gets the information related to the AA specified in input parameter
*
*    - Generates BULK OFS MESSAGES to apply payments to corresponding AA
*
* ====================================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : pgarzongavilanes
* Date            : Jun-01-2011

* Development for : APAP
* Development by  : PABLO CASTILLO DE LA ROSA
* Date            : Apr-30-2012

* Ammend for :  APAP
* Ammed by   : mgudino
* Date       :  Nov-20-2012

*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.REDO.COLLATERAL.REA
    $INSERT I_GTS.COMMON
*
*************************************************************************
*


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

*
RETURN
*
* ======
PROCESS:
* ======

    CALL F.READ(FN.REDO.COLLATERAL.REA, Y.REDO.COLLATERAL.REA.ID, R.REDO.COLLATERAL.REA, F.REDO.COLLATERAL.REA, Y.ERR.REDO.COLLATERAL.REA)

    PERC.F.Y = R.REDO.COLLATERAL.REA<R.COL.REA.PERC.FIVE.YEARS>
    PERCENTAGE = R.REDO.COLLATERAL.REA<R.COL.REA.PERCENTAGE>

*VALIDATE % FOR GARANTY CLASS EXISTS
    IF LEN(PERCENTAGE) EQ 0 THEN
        PERCENTAGE = 0
* R.NEW(COLL.CENTRAL.BANK.VALUE)= 0
* *AF = 14
* ETEXT = 'ST-PARAM.REA'
* CALL STORE.END.ERROR
    END


    IF PERC.F.Y EQ '' THEN
*** DONT CALC WITH YEAR : 356 y 357
        Y.CENTRAL.BANK.VALUE = Y.NOMINAL.VALUE * PERCENTAGE / 100
    END
    ELSE
*** CALC WITH YEARS AND USE PERCENTAJE FIVE YEARS IF CONDITION APPLY: 351, 352, 353, 354 y 355

        Y.VALUE.YEAR = RIGHT(Y.VALUE.DATE, 4)


        NUM.YEARS = Y.VALUE.YEAR - Y.BLOCK.NO

        IF NUM.YEARS GT 5 THEN
            Y.CENTRAL.BANK.VALUE = Y.NOMINAL.VALUE * PERC.F.Y / 100
        END
        ELSE
            Y.CENTRAL.BANK.VALUE = Y.NOMINAL.VALUE * PERCENTAGE / 100
        END
    END

    Y.CENTRAL.BANK.VALUE = DROUND(Y.CENTRAL.BANK.VALUE,2)     ;* PACS00307565 - S/E

    R.NEW(COLL.CENTRAL.BANK.VALUE) = Y.CENTRAL.BANK.VALUE

RETURN
*
* =========
OPEN.FILES:
* =========
*
    CALL OPF(FN.REDO.COLLATERAL.REA, F.REDO.COLLATERAL.REA)
RETURN

*
* =========
INITIALISE:
* =========
*
    WCAMPO    = "L.COL.SEC.DESC"
***WCAMPO<2> = ""
***WCAMPO<3> = ""
***WCAMPO    = CHANGE(WCAMPO,FM,VM)

    YPOS = ''

    CALL MULTI.GET.LOC.REF("COLLATERAL",WCAMPO,YPOS)
    WPOS.BLOCK.NO = YPOS<1,1>
***WPOS2  = YPOS<1,2>
***WPOS3 = YPOS<1,3>

    Y.COLLATERAL.TYPE = R.NEW(COLL.COLLATERAL.TYPE) ;*** CLASE GARANTIA
    Y.VALUE.DATE = R.NEW(COLL.VALUE.DATE) ;*** FECHA CREACION GARANTIA
*Y.NOMINAL.VALUE = R.NEW(COLL.NOMINAL.VALUE) ; *** VALOR NOMINAL


***VERIFY THE TYPE SELECTION.****
    IF LEN(TRIM(Y.COLLATERAL.TYPE)) EQ 0 THEN

*EXCECUTE ONLY IF PRESS HOT FIELD
        VAR.HOT = OFS$HOT.FIELD
        IF LEN(VAR.HOT) GT 0 THEN
            TEXT   = "COLL.SEL.TYPE"
            M.CONT = DCOUNT(R.NEW(COLL.VALUE.DATE),@VM) + 1 ;*R22 AUTO CONVERSION
            CALL STORE.OVERRIDE(M.CONT)
        END
*TEXT   = "COLL.SEL.TYPE"
*M.CONT = DCOUNT(R.NEW(COLL.VALUE.DATE),VM) + 1
*CALL STORE.OVERRIDE(M.CONT)

    END

*BY READ THE NOMINAL VALUE FOR DIFERENTS POSITIONS OF ROUTINE PCR

    APP.NAME=APPLICATION
    FIELD.NO='NOMINAL.VALUE'
    CALL EB.GET.APPL.FIELD(APP.NAME,FIELD.NO,'',Y.APP.ERR)

    IF AF EQ FIELD.NO THEN
        Y.NOMINAL.VALUE = COMI
    END ELSE
        Y.NOMINAL.VALUE = R.NEW(COLL.NOMINAL.VALUE)   ;*** VALOR NOMINAL
    END

    Y.BLOCK.NO = R.NEW(COLL.LOCAL.REF)<1,WPOS.BLOCK.NO>       ;*** ANIO FABRICACION
    Y.CENTRAL.BANK.VALUE = ''

    FN.REDO.COLLATERAL.REA = 'F.REDO.COLLATERAL.REA'
    F.REDO.COLLATERAL.REA = ''
    R.REDO.COLLATERAL.REA = ''
    Y.REDO.COLLATERAL.REA.ID = Y.COLLATERAL.TYPE
    Y.ERR.REDO.COLLATERAL.REA = ''


    PROCESS.GOAHEAD = 1
    LOOP.CNT = 0
    MAX.LOOPS = 1



RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1


        END CASE

        LOOP.CNT +=1
    REPEAT
*
RETURN
*

END
