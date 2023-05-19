* @ValidationCode : MjozNDkyNzIxOTU6Q3AxMjUyOjE2ODQzMjk3MjE2NjY6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 May 2023 18:52:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.BALANCE.NOFILE.AUDIT.ENQ(Y.ARRAY)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RIYAS
* PROGRAM NAME: REDO.BALANCE.NOFILE.AUDIT.ENQ
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Routine for NOFILE enquiry to REDO.BALANCE.NOFILE.AUDIT.ENQ
* it fetches all prodcut for the customer
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.03.2010  H GANESH     ODR-2009-10-0838   INITIAL CREATION
** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion -CALL RTN FORMAT MODIFIED
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    GOSUB INIT
    GOSUB GET.VALUES
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    Y.CUS.ID = ''
    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
RETURN
*----------------------------------------------------------------------
GET.VALUES:
*----------------------------------------------------------------------

    LOCATE 'CUSTOMER' IN D.FIELDS<1> SETTING Y.POS1 THEN
        Y.CUS.ID = FIELD(D.RANGE.AND.VALUE<Y.POS1>,'-',1)
    END
    LOCATE 'LETTER.TYPE' IN D.FIELDS<1> SETTING Y.POS2 THEN
        Y.LETTER.TYPE=FIELD(D.RANGE.AND.VALUE<Y.POS2>,'-',1)
    END
RETURN
*----------------------------------------------------------------------
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    IF Y.LETTER.TYPE EQ 'BALANCE' THEN
        SEL.CMD= 'SELECT ':FN.AA.ARRANGEMENT:' WITH CUSTOMER EQ ':Y.CUS.ID:' AND (ARR.STATUS EQ MATURED OR ARR.STATUS EQ EXPIRED)'
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
        LOOP
            REMOVE IN.ARR.ID FROM SEL.LIST SETTING Y.BAL.POS
        WHILE IN.ARR.ID:Y.BAL.POS
*CALL REDO.CONVERT.ACCOUNT(Y.ARR.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)  ;*R22 MANUAL CODE CONVERSION
            CALL APAP.TAM.redoConvertAccount(Y.ARR.ID,IN.ARR.ID,OUT.ID,ERR.TEXT) ;*R22 MANUAL CODE CONVERSION
            Y.ARRAY<-1> = OUT.ID
        REPEAT

    END
RETURN
***********************************************************************
