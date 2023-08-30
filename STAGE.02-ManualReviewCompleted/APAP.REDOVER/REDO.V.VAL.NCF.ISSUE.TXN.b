* @ValidationCode : Mjo4MTc0NTYzOTg6Q3AxMjUyOjE2ODE3MzAwNTYyMTQ6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 16:44:16
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.NCF.ISSUE.TXN
*------------
*DESCRIPTION:
*------------
* This routine is used to create a Template named REDO.L.NCF.ISSUE
*

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 23-JAN-2010         Prabhu N       PACS00169424         Initial Creation
* ----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.L.NCF.ISSUE
    $INSERT I_Table


    Y.TXN.ID = R.NEW(NCF.IS.TXN.REFERENCE)
    Y.AVAIL=1

    GOSUB INIT
    GOSUB PROCESS.LIVE.READ

    IF NOT(Y.AVAIL) THEN
        ETEXT='EB-NO.RECORD'
        CALL STORE.END.ERROR
    END

RETURN
*-------
INIT:
*-------
    FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER =''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.FUNDS.TRANSFER$HIS='F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER$HIS=''
    CALL OPF(FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)

    FN.TELLER='F.TELLER'
    F.TELLER =''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER$HIS='F.TELLER$HIS'
    F.TELLER$HIS=''
    CALL OPF(FN.TELLER$HIS,F.TELLER$HIS)

    FN.DATA.CAPTURE='F.DATA.CAPTURE'
    F.DATA.CAPTURE =''
    CALL OPF(FN.DATA.CAPTURE,F.DATA.CAPTURE)

    FN.DATA.CAPTURE$HIS='F.DATA.CAPTURE$HIS'
    F.DATA.CAPTURE$HIS =''
    CALL OPF(FN.DATA.CAPTURE$HIS,F.DATA.CAPTURE$HIS)

RETURN
*----------------
PROCESS.LIVE.READ:
*----------------
    Y.ERR=''
    CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.ID,R.RECORD,F.FUNDS.TRANSFER,Y.ERR)
    IF Y.ERR THEN
        Y.ERR=''
        CALL F.READ(FN.TELLER,Y.TXN.ID,R.RECORD,F.TELLER,Y.ERR)
        IF Y.ERR THEN
            Y.ERR=''
            CALL F.READ(FN.DATA.CAPTURE,Y.TXN.ID,R.RECORD,F.DATA.CAPTURE,Y.ERR)
            IF Y.ERR THEN
                GOSUB PROCESS.HIST.READ
            END
        END
    END
RETURN

*----------------
PROCESS.HIST.READ:
*----------------
    CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER$HIS,Y.TXN.ID,R.RECORD,Y.ER)
    IF Y.ER THEN
        Y.ER=''
        CALL EB.READ.HISTORY.REC(F.TELLER$HIS,Y.TXN.ID,R.RECORD,Y.ER)
        IF Y.ER THEN
            Y.ER=''
            CALL EB.READ.HISTORY.REC(F.DATA.CAPTURE$HIS,Y.TXN.ID,R.RECORD,Y.ER)
            IF Y.ER THEN
                Y.AVAIL=''
            END
        END
    END
RETURN
END
