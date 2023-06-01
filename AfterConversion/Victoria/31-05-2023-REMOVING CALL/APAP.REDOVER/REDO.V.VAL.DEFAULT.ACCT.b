* @ValidationCode : MjoxNTY2MDU4MjE6Q3AxMjUyOjE2ODI0MTIzNTk4NTY6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE  REDO.V.VAL.DEFAULT.ACCT
*-------------------------------------------------------------------------
*DESCRIPTION:
*~~~~~~~~~~~~
* This routine is attached as VALIDATION routine in VERSION.CONTROL
*
*
*-------------------------------------------------------------------------
*DEVELOPMENT DETAILS:
*~~~~~~~~~~~~~~~~~~~~
*
*   Date            who             Reference            Description
*   ~~~~            ~~~             ~~~~~~~~~            ~~~~~~~~~~~
*   02-JUN-2010     SHANKAR RAJU    ODR-2010-03-0447     Initial Creation
*   21-FEB-2011     KAVITHA         HD1054080-S          REDO.H.BANK.DRAFTS changes
*   27-JAN-2012     NAVA V.                              To be used only for VALIDATION FIELD event.
*   02-FEB-2012     J.COSTA C.      PACS00163682         Store USER VARIABLES
*   23-MAR-2012     NAVA V.         PACS00172913         Cheque calculation moved to REDO.V.INP.DEFAULT.ACCT.
*-------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
*
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
*
    GOSUB INIT
    GOSUB CHECK.PRELIM.CONDITIONS
*
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*---------------------------------------------------------------------------
*
* ======
PROCESS:
* ======
*
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        R.NEW(FT.CREDIT.ACCT.NO) = COMI
    END
*
    IF APPLICATION EQ 'TELLER' THEN
        IF R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" THEN
            R.NEW(TT.TE.ACCOUNT.1) = COMI
        END ELSE
            R.NEW(TT.TE.ACCOUNT.2) = COMI
        END
    END
*
RETURN
*
*----------------------------------------------------------------------------
*
* ===
INIT:
* ===
*
    PROCESS.GOAHEAD      = 1
*
RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
    LOOP.CNT  = 1
    MAX.LOOPS = 2
*
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE

            CASE LOOP.CNT EQ 1

                IF MESSAGE EQ "VAL" THEN
                    PROCESS.GOAHEAD = ""
                END

            CASE LOOP.CNT EQ 2

        END CASE
        LOOP.CNT +=1
*
    REPEAT
*
RETURN
*
END
