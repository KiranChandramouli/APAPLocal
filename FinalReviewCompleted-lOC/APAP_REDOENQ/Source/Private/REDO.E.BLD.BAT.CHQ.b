* @ValidationCode : Mjo1MzM5MDk4MDc6Q3AxMjUyOjE2ODIwNzMzODIxNjA6SVRTUzotMTotMToxNDQ4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1448
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.BAT.CHQ(ENQ.DATA)
*----------------------------------------------------------------------------
* Description:
***************
*
*  This build routine is to be attached to the ENQUIRY REDO.GEN.BAT.CHQ.BY.TELLER
*  to generate the sequence ID for REDO.H.BAT.CHQ.DETAILS and to create entries in
*  REDO.H.BAT.CHQ.DETAILS file and REDO.H.CHECK.CLEARING.SCREEN file
*
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : ENQ.DATA
* OUT    : ENQ.DATA
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NATCHIMUTHU.P
* PROGRAM NAME : REDO.E.BLD.BAT.CHQ
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 15.07.2010      NATCHIMUTHU.P  ODR-2010-02-0001    INITIAL CREATION
*
* 13-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_TT.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.LOCKING
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.REDO.H.CLEARING.OUTWARD
    $INSERT I_F.REDO.H.BAT.CHQ.DETAILS
    $INSERT I_F.REDO.H.CHECK.CLEARING.SCREEN

    GOSUB INIT
    GOSUB PROCESS
    GOSUB CHECK.CLEARING.SCREEN

RETURN

*-----------------------------------------------------------------------------------------------
********
INIT:
********

    FN.TELLER='F.TELLER'
    F.TELLER=''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.REDO.H.CLEARING.OUTWARD='F.REDO.H.CLEARING.OUTWARD'
    F.REDO.H.CLEARING.OUTWARD=''
    CALL OPF(FN.REDO.H.CLEARING.OUTWARD,F.REDO.H.CLEARING.OUTWARD)

    FN.REDO.H.BAT.CHQ.DETAILS = 'F.REDO.H.BAT.CHQ.DETAILS'
    F.REDO.H.BAT.CHQ.DETAILS = ''
    CALL OPF(FN.REDO.H.BAT.CHQ.DETAILS,F.REDO.H.BAT.CHQ.DETAILS)

    FN.LOCKING='F.LOCKING'
    F.LOCKING=''
    CALL OPF(FN.LOCKING,F.LOCKING)

    FN.REDO.H.CHECK.CLEARING.SCREEN='F.REDO.H.CHECK.CLEARING.SCREEN'
    F.REDO.H.CHECK.CLEARING.SCREEN=''
    CALL OPF(FN.REDO.H.CHECK.CLEARING.SCREEN,F.REDO.H.CHECK.CLEARING.SCREEN)

    R.REDO.H.BAT.CHQ.DETAILS=''
    R.CLR.OUTWARD.RECORD=''
    R.REDO.H.CHECK.CLEARING.SCREEN=''

RETURN
*----------------------------------------------------------------------------------------------------------
*********
PROCESS:
*********
    P.TELLER.ID=TT$TID
    LOCATE "TELLER.ID" IN ENQ.DATA<2,1> SETTING TELLER.ID.POS ELSE NULL
    Y.TELLER.ID = ENQ.DATA<4,TELLER.ID.POS>

    ENQ.DATA<2,1>='TELLER.ID'
    ENQ.DATA<3,TELLER.ID.POS>='EQ'
    ENQ.DATA<4,TELLER.ID.POS>=P.TELLER.ID

    SYS.DATE.NOW = OCONV(DATE(),"D-")
    SYS.DATE.NOW = SYS.DATE.NOW[9,2]:SYS.DATE.NOW[1,2]:SYS.DATE.NOW[4,2]
    CURRENT.TIME = TIMEDATE()[1,2]:TIMEDATE()[4,2]
    GOSUB SEQUENCE.NO.FORMATION
RETURN
*-----------------------------------------------------------------------------------------------------------
**************************
SEQUENCE.NO.FORMATION:
**************************
    CALL F.READU(FN.LOCKING,'REDO.H.BAT.CHQ.DETAILS',R.LOCKING,F.LOCKING,LOCK.ERR,RETRY)
    IF R.LOCKING NE '' THEN
        Y.LOCK.START.ID = R.LOCKING<EB.LOK.CONTENT> + 1
        Y.LOCK.START.ID = FMT(Y.LOCK.START.ID,'10"0"R')
    END ELSE
        Y.LOCK.START.ID = R.LOCKING<EB.LOK.CONTENT>
    END
    R.LOCKING<EB.LOK.CONTENT> = Y.LOCK.START.ID
    CALL F.WRITE(FN.LOCKING,'REDO.H.BAT.CHQ.DETAILS',R.LOCKING)
    GOSUB BATCH.ID.FORMARMATION
RETURN
* ----------------------------------------------------------------------------------------------
BATCH.ID.FORMARMATION:
*-----------------------------------------------------------------------------------------------
    Y.ID = 'BC':TT$TID:TODAY:CURRENT.TIME:Y.LOCK.START.ID
    COMI=Y.ID
    DUMMY(3)=Y.ID
* -----------------------------------------------------------------------------------------------------------
    Y.TIMEDATE=TIMEDATE()
    Y.TIME=Y.TIMEDATE[1,5]

    CALL F.READ(FN.REDO.H.BAT.CHQ.DETAILS,Y.ID,R.REDO.H.BAT.CHQ.DETAILS,F.REDO.H.BAT.CHQ.DETAILS,Y.ERR)

    R.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.BRANCH.ID>=ID.COMPANY
    R.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.TELLER.ID>=P.TELLER.ID
    R.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.TELLER.NAME>=OPERATOR
    R.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.BATCH.GEN.DATE>=TODAY
    R.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.BATCH.GEN.TIME>=Y.TIME
*   R.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.DATE.TIME>=Y.TIMEDATE
    R.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.CO.CODE>=ID.COMPANY
    R.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
* ------------------------------------------------------------------------------------------
*  Create entries in REDO.H.BAT.CHQ.DETAILS file
* -------------------------------------------------------------------------------------------
    SEL.CMD2 = "SELECT ":FN.REDO.H.CLEARING.OUTWARD:" WITH TELLER.ID EQ ":P.TELLER.ID
    CALL EB.READLIST(SEL.CMD2,SEL.LIST2,'',NOR1,SEL.ERR2)
    LOOP
        REMOVE Y.CLR.OUTWARD.ID FROM SEL.LIST2 SETTING POS2

    WHILE Y.CLR.OUTWARD.ID:POS2
        CALL F.READ(FN.REDO.H.CLEARING.OUTWARD,Y.CLR.OUTWARD.ID,R.CLR.OUTWARD.REC,F.REDO.H.CLEARING.OUTWARD,CLR.ERR1)

        Y.NO.OF.CHEQUES+= R.CLR.OUTWARD.REC<REDO.CLR.OUT.NO.OF.CHEQUE>
        Y.AMOUNT+= R.CLR.OUTWARD.REC<REDO.CLR.OUT.AMOUNT>
    REPEAT
    R.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.TOTAL.CHQ.AMT>= Y.AMOUNT:'.00'
    R.REDO.H.BAT.CHQ.DETAILS<REDO.BAT.CHQ.TOTAL.CHEQUES> = Y.NO.OF.CHEQUES

    CALL F.WRITE(FN.REDO.H.BAT.CHQ.DETAILS,Y.ID,R.REDO.H.BAT.CHQ.DETAILS)
RETURN
*---------------------------------------------------------------------------------------------------------
*   Create entries in REDO.H.CHECK.CLEARING.SCREEN file
*---------------------------------------------------------------------------------------------------------
***********************
CHECK.CLEARING.SCREEN:
***********************
    SEL.CMD3 = "SELECT ":FN.REDO.H.CLEARING.OUTWARD:" WITH TELLER.ID EQ ":P.TELLER.ID
    CALL EB.READLIST(SEL.CMD3,SEL.LIST3,'',NOR2,SEL.ERR2)
    LOOP
        REMOVE Y.CLR.OUTWARD.ID1 FROM SEL.LIST3 SETTING POS3

    WHILE Y.CLR.OUTWARD.ID1:POS3
        CALL F.READ(FN.REDO.H.CLEARING.OUTWARD,Y.CLR.OUTWARD.ID1,R.CLR.OUTWARD.RECORD,F.REDO.H.CLEARING.OUTWARD,CLR.ERR)

        Y.AMOUNT=R.CLR.OUTWARD.RECORD<REDO.CLR.OUT.AMOUNT>
        Y.CO.CODE=R.CLR.OUTWARD.RECORD<REDO.CLR.OUT.CO.CODE>
        Y.ACCT.NO=R.CLR.OUTWARD.RECORD<REDO.CLR.OUT.ACCOUNT.NUMBER>
        Y.NO.OF.CHQ=R.CLR.OUTWARD.RECORD<REDO.CLR.OUT.NO.OF.CHEQUE>
        Y.CCY=R.CLR.OUTWARD.RECORD<REDO.CLR.OUT.CURRENCY>

        R.CLR.OUTWARD.RECORD<REDO.CLR.OUT.TRANSFER>="READY"
        CALL F.WRITE(FN.REDO.H.CLEARING.OUTWARD,Y.CLR.OUTWARD.ID1,R.CLR.OUTWARD.RECORD)

*      -------------------------------------------------------------------------------------------------------------

        CALL F.READ(FN.REDO.H.CHECK.CLEARING.SCREEN,Y.CLR.OUTWARD.ID1,R.REDO.H.CHECK.CLEARING.SCREEN,F.REDO.H.CHECK.CLEARING.SCREEN,Y.ERROR)

        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.INIT.DEP.REF>=Y.CLR.OUTWARD.ID1
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.TT.DEP.AMOUNT>=Y.AMOUNT
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.ROUTING.NO>='1'
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.BANK.CODE>=Y.CO.CODE
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.ACCOUNT.NO>=Y.ACCT.NO
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.RECORD.STATUS>='IHLD'
*       R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.DATE.TIME>=TIMEDATE()
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.NO.OF.CHECKS>=Y.NO.OF.CHQ
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.CCY>=Y.CCY
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.CR.ACCOUNT>=Y.ACCT.NO
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.AMOUNT>=Y.AMOUNT
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.DR.ACCOUNT>=''
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.CO.CODE>=ID.COMPANY
        R.REDO.H.CHECK.CLEARING.SCREEN<REDO.CHK.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
        CALL F.WRITE(FN.REDO.H.CHECK.CLEARING.SCREEN,Y.CLR.OUTWARD.ID1,R.REDO.H.CHECK.CLEARING.SCREEN)
*     CALL JOURNAL.UPDATE('')
    REPEAT
RETURN
END

*-------------------------------------------------------------------------------------------------------------------------------
* PROGRAM END
* -------------------------------------------------------------------------------------------------------------------------------
