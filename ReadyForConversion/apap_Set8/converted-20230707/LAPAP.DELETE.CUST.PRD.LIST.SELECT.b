*========================================================================
SUBROUTINE LAPAP.DELETE.CUST.PRD.LIST.SELECT
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.DELETE.CUST.PRD.LIST.SELECT
* Date           : 2018-01-31
* Item ID        : CN00
*========================================================================
* Brief description :
* -------------------
* This a multi-threading program for inject data in monitor interface
* without use any version.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-01-31     Richard HC        Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :
* Auto Increment : N/A
* Views/versions : N/A
* EB record      : LAPAP.DELETE.CUST.PRD.LIST.SELECT
* Routine        : LAPAP.DELETE.CUST.PRD.LIST.SELECT
*========================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_LAPAP.DELETE.CUST.PRD.LIST


    DIR.NAME = "&SAVEDLISTS&"
    FILE.NAME = "LAPAP.DELETE.CUST.PRD.LIST.TXT"

    OPENSEQ DIR.NAME,FILE.NAME TO FV.REC ELSE
        PRINT @(12,12): 'CANNOT OPEN DIRECTORY'
    END
    LOOP
        READSEQ Y.REC FROM FV.REC ELSE Y.EOF = 1
    WHILE NOT(Y.EOF)

        ARR<-1> = Y.REC

    REPEAT
    CLOSESEQ FV.REC

    CALL BATCH.BUILD.LIST('',ARR)

END
