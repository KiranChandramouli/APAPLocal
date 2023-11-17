* @ValidationCode : MjotMTU4NDY1ODk5ODpDcDEyNTI6MTY5Nzc5MTQ1MzUyOTpJVFNTOi0xOi0xOjEyODE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Oct 2023 14:14:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1281
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.STATUS1.UPDATE
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.STATUS1.UPDATE
*------------------------------------------------------------------
* Description : This is the update rotuine which will find out the status
* of the customer accounts based on a particular time period
*------------------------------------------------------------------
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              05-07-2011       PACS00084781       Selecting only saving,current,sweep account
* Jayasurya            30-05-2023       TSR-571603
* Edwin                20 AUG 2023      TSR-637100
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.UPD.ACC.LIST
    $INSERT I_F.REDO.T.ACCTSTAT.BY.DATE

    GOSUB SEL.PROCESS
    GOSUB PROCESS.ALL
RETURN
*-------------------------------------------------------------------------
SEL.PROCESS:
*-------------------------------------------------------------------------
    FN.REDO.UPD.ACC.LIST = 'F.REDO.UPD.ACC.LIST'
    F.REDO.UPD.ACC.LIST = ''
    CALL OPF(FN.REDO.UPD.ACC.LIST,F.REDO.UPD.ACC.LIST)

    FN.REDO.T.ACCTSTAT.BY.DATE = 'F.REDO.T.ACCTSTAT.BY.DATE'
    F.REDO.T.ACCTSTAT.BY.DATE = ''
    CALL OPF(FN.REDO.T.ACCTSTAT.BY.DATE,F.REDO.T.ACCTSTAT.BY.DATE)
    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES,F.DATES)
    FN.SL = '&SAVEDLISTS&/TEMP.ACCOUNTS'
    F.SL = ''
    CALL OPF(FN.SL,F.SL)
    Y.LAST.WRKN.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.TODAY = R.DATES(EB.DAT.TODAY)

*SEL.CMD = 'SELECT ':FN.REDO.UPD.ACC.LIST:' WITH @ID LIKE ':Y.LAST.WRKN.DATE:'-...'
    SEL.CMD = 'SELECT ':FN.REDO.UPD.ACC.LIST:' WITH @ID LIKE ':Y.TODAY:'-...'

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,Y.ERR)
RETURN
*-------------------------------------------------------------------------
PROCESS.ALL:
*-------------------------------------------------------------------------
    Y.ACCOUNT.NUMBER = ''
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS
    WHILE Y.ID:POS
        CALL F.READ(FN.REDO.UPD.ACC.LIST,Y.ID,R.REDO.UPD.ACC.LIST,F.REDO.UPD.ACC.LIST,Y.ERR.R)
        Y.ACCOUNT.NUMBER<-1> = R.REDO.UPD.ACC.LIST
        CALL F.DELETE(FN.REDO.UPD.ACC.LIST,Y.ID)
    REPEAT
    CHANGE @VM TO @FM IN Y.ACCOUNT.NUMBER ;*R22 MANUAL CONVERSION
    R.REDO.UPD.ACC.LIST.BK<AL.ACCOUNT> = Y.ACCOUNT.NUMBER
    IF Y.ACCOUNT.NUMBER THEN
*CALL F.WRITE(FN.REDO.UPD.ACC.LIST,Y.LAST.WRKN.DATE,R.REDO.UPD.ACC.LIST.BK)
        CALL F.WRITE(FN.REDO.UPD.ACC.LIST,Y.TODAY,R.REDO.UPD.ACC.LIST.BK)
    END
    SEL.CMD.SL = "SELECT ":FN.SL
    CALL EB.READLIST(SEL.CMD.SL,SEL.LIST.SL,'',NO.OF.REC.SL,RET.CODE.SL)
    FINAL.ARRAY.LIST =''
    LOOP
        REMOVE Y.TEMP.ID FROM SEL.LIST.SL SETTING SEL.POS.SL
    WHILE Y.TEMP.ID:SEL.POS.SL
        R.SL = ''; TEMP.ERR.SL = ''
        CALL F.READ(FN.SL,Y.TEMP.ID,R.SL, F.SL,TEMP.ERR.SL)
        FINAL.ARRAY.LIST<-1> = R.SL
        DELETE F.SL,Y.TEMP.ID
    REPEAT
    CHANGE @FM TO @VM IN FINAL.ARRAY.LIST ;*R22 MANUAL CONVERSION
    IF FINAL.ARRAY.LIST THEN
        R.DATE = ''
        CALL F.READ(FN.DATES,'DO0010001',R.DATE,F.DATES,DAT.ERR)

        IF RUNNING.UNDER.BATCH THEN
            CURR.DATE = R.DATE<EB.DAT.LAST.WORKING.DAY>
        END

        CALL F.READ(FN.REDO.T.ACCTSTAT.BY.DATE,CURR.DATE,R.REDO.T.ACCTSTAT.BY.DATE,F.REDO.T.ACCTSTAT.BY.DATE,DATE.ERR)  ;* TSR637100

        R.REDO.T.ACCTSTAT.BY.DATE<REDAT.ACCOUNT,-1>= FINAL.ARRAY.LIST
        WRITE R.REDO.T.ACCTSTAT.BY.DATE ON F.REDO.T.ACCTSTAT.BY.DATE,CURR.DATE
    END
RETURN
END
