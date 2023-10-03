* @ValidationCode : MjoxNjU3MzIxNzkyOkNwMTI1MjoxNjkzOTkxMjUyNTcxOnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Sep 2023 14:37:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*-----------------------------------------------------------------------------
* <Rating>-44</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE AT.GET.BAL.AFT.TXN(ACCT.NO,FMT.ACCT.BAL)
*
* Subroutine Type : PROCEDURE
* Attached to     : N/A
* Attached as     : N/A
* Primary Purpose : To return the Formatted Account Balance
*
* Incoming:
* ---------
* ACCT.NO - Account Number
*
* Outgoing:
* ---------
* FMT.ACCT.BAL - Formatted Account Balance
*
* Error Variables:
* ----------------
* NONE
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 04/JAN/2007 - Naveen
*               ATM Interface
*
*-----------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*06-09-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE MODIFIED
*----------------------------------------------------------------------------------------
*    $INCLUDE T24.BP I_COMMON	;*/ TUS START
*    $INCLUDE T24.BP I_EQUATE
*    $INCLUDE T24.BP I_F.ACCOUNT
*    $INCLUDE T24.BP I_GTS.COMMON

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON
    $INSERT I_F.EB.CONTRACT.BALANCES	;*/ TUS END
    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*
*CALL AT.ISO.FMT.BAL.RTN(R.ACCT,WRK.BAL,AVAIL.BAL,ACCT.BAL)
    APAP.ATM.atIsoFmtBalRtn(R.ACCT,WRK.BAL,AVAIL.BAL,ACCT.BAL) ;*R22 MANUAL CONVERSION
    FMT.ACCT.BAL = ACCT.BAL

RETURN
*-----------------------------------------------------------------------------------
*//////////////////////////////////////////////////////////////////////////////////*
*////////////////P R E  P R O C E S S  S U B R O U T I N E S //////////////////////*
*//////////////////////////////////////////////////////////////////////////////////*
INITIALISE:
*
    PROCESS.GOAHEAD = 1
    FMT.ACCT.BAL = '' ; WRK.BAL = '' ; AVAIL.BAL = '' ; ACCT.BAL = ''

RETURN
*-----------------------------------------------------------------------------------
OPEN.FILES:
*
    FN.ACCOUNT = 'F.ACCOUNT'
    FN.ACCOUNT<2> = 'NO.FATAL.ERROR'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*
    LOOP.CNT = 1 ; MAX.LOOPS = 3
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO

        BEGIN CASE
            CASE LOOP.CNT EQ 1
                IF ETEXT THEN     ;* Any OPF Errors
                    PROCESS.GOAHEAD = 0
                END

            CASE LOOP.CNT EQ 2
                IF NOT(ACCT.NO) THEN
                    PROCESS.GOAHEAD = 0
                END

            CASE LOOP.CNT EQ 3
                R.ACCT = '' ; ERR.ACCT = ''
                CALL F.READ(FN.ACCOUNT,ACCT.NO,R.ACCT,F.ACCOUNT,ERR.ACCT)
                CALL EB.READ.HVT('EB.CONTRACT.BALANCES',ACCT.NO,R.ECB,ECB.ERR)	;*/ TUS S/E
                IF ERR.ACCT THEN
                    PROCESS.GOAHEAD = 0
                END ELSE
*                WRK.BAL = R.ACCT<AC.WORKING.BALANCE>	;*/TUS S/E
                    WRK.BAL = R.ECB<ECB.WORKING.BALANCE>
                END

        END CASE
        LOOP.CNT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------
END
