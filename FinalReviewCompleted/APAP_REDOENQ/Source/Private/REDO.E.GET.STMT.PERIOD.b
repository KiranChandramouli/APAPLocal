<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : MjoxMzQ2OTc0MTM0OkNwMTI1MjoxNjkwMjY1MjA5NDI3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:36:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
=======
=======
>>>>>>> Stashed changes
* @ValidationCode : MjotMTUxNzE2NjcxMTpDcDEyNTI6MTY4NjY3NTU3MzExMjpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:29:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
=======
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.GET.STMT.PERIOD(Y.FINAL.ARRAY)
*---------------------------------------------------------------------------------
* This is aenquiry for list the details of credit card
*this enquiry will fetch the data from sunnel interface
*---------------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : Prabhu N
* Program Name   : REDO.E.GET.STMT.PERIOD
* ODR NUMBER     : SUNNEL-CR
* LINKED WITH    : ENQUIRY-REDO.CCARD.STMT.PERIOD
*---------------------------------------------------------------------------------
*IN = N/A
*OUT = Y.FINAL.ARRAY
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*3.12.2010     SUNNEL                 Prabhu N                Initial creation
*21-04-2011    PACS00032454           GANESH H                 MODIFICAION
*09.06.2023    Santosh         R22 Manual Conversion          Added package and Y.MSG.ST and Y.OFF intialized
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_System
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    $USING APAP.REDOVER
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

    GOSUB INITIALISE
*    GOSUB PROCESS
    GOSUB SET.VARS
RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------
    LOCATE 'CURRENCY' IN  D.FIELDS SETTING Y.CUR.POS THEN
        Y.CUR.VAL=D.RANGE.AND.VALUE<Y.CUR.POS>
    END

*PACS00032454-S
    LOCATE 'START.DATE' IN D.FIELDS SETTING Y.MON.POS THEN
    END
    CUR.MONTH=D.RANGE.AND.VALUE<3>
    CUR.YEAR =D.RANGE.AND.VALUE<4>

    FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
    F.REDO.EB.USER.PRINT.VAR =''
    CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)


    Y.CUSTOMER.ID=System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CUSTOMER.ID = ""
    END

*    CARD.NO    =System.getVariable('CURRENT.CACC.NO')

    Y.USR.VAR  = System.getVariable("EXT.EXTERNAL.USER")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.USR.VAR = ""
    END
    Y.CCARD.ENQ= System.getVariable("CURRENT.CCARD.ENQ")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.CCARD.ENQ = ""
    END




    BEGIN CASE
        CASE Y.CCARD.ENQ EQ 'AI.REDO.CCARD.LIM.PERIOD.CUR.MTH'
            Y.MTH = '1'
        CASE Y.CCARD.ENQ EQ 'AI.REDO.CCARD.LIM.PERIOD.PREV.MTH'
            Y.MTH= '2'
        CASE Y.CCARD.ENQ EQ 'AI.REDO.CCARD.LIM.PERIOD.PREV.TWO.MTH'
            Y.MTH= '3'
    END CASE


    Y.HTML.VAR = Y.USR.VAR:"-":"CURRENT.CARD.CORTE"

*  READ HTML.HEADER FROM F.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR ELSE ;*Tus Start
    CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.HTML.VAR,HTML.HEADER,F.REDO.EB.USER.PRINT.VAR,HTML.HEADER.ERR)
    IF HTML.HEADER.ERR THEN  ;* Tus End
        HTML.HEADER = ''
    END
    CARD.NO=HTML.HEADER<1,1>
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER =''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.ERR)
    Y.NAME      =R.CUSTOMER<EB.CUS.GIVEN.NAMES>
    Y.DIRECCION = R.CUSTOMER<EB.CUS.ADDRESS>

*PACS00032454-E
*    IF Y.CUR.VAL EQ 'DOP' THEN
    D.RANGE.AND.VALUE<Y.CUR.POS>=1
*    END
*    ELSE
*        D.RANGE.AND.VALUE<Y.CUR.POS>=2
*    END
    Y.MTH.CNT='1'
    Y.DB.TOT=''
    Y.CR.TOT=''
    D.RANGE.AND.VALUE<Y.MON.POS>=D.RANGE.AND.VALUE<Y.MON.POS> - Y.MTH + Y.MTH.CNT - 1
    LOOP
    WHILE Y.MTH.CNT LE Y.MTH
        Y.ARRAY='BE_K_TC.BE_P_CON_ESTCUENTATC_A'
        D.RANGE.AND.VALUE<Y.MON.POS>=D.RANGE.AND.VALUE<Y.MON.POS> + 1
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*       CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
        APAP.REDOVER.redoVWrapSunnel(Y.ARRAY) ;*R22 Manual Code Converison
=======
        CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
>>>>>>> Stashed changes
=======
        CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
>>>>>>> Stashed changes
        GOSUB PROCESS
        Y.MTH.CNT += 1
    REPEAT
    D.RANGE.AND.VALUE<Y.CUR.POS>=2
    Y.MTH.CNT='1'
    Y.DB.TOT=''
    Y.CR.TOT=''
    D.RANGE.AND.VALUE<Y.MON.POS>=D.RANGE.AND.VALUE<Y.MON.POS> - Y.MTH + Y.MTH.CNT -1
    LOOP
    WHILE Y.MTH.CNT LE Y.MTH
        Y.ARRAY='BE_K_TC.BE_P_CON_ESTCUENTATC_A'
        D.RANGE.AND.VALUE<Y.MON.POS>=D.RANGE.AND.VALUE<Y.MON.POS> + 1
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*       CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
        APAP.REDOVER.redoVWrapSunnel(Y.ARRAY)   ;*R22 Manual Code Converison
=======
        CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
>>>>>>> Stashed changes
=======
        CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
>>>>>>> Stashed changes
        GOSUB PROCESS
*    CARD.NO= System.getVariable('CURRENT.CARD.ID')
        Y.MTH.CNT += 1
    REPEAT

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------


    Y.MSG.DESC=Y.ARRAY<29>
    Y.ALL.DATA=Y.ARRAY<25>

    IF Y.ARRAY<28> NE '0' THEN
        RETURN
    END

    Y.ROWS=DCOUNT(Y.ALL.DATA,@VM)
    CHANGE @VM TO @FM IN Y.ALL.DATA
    CHANGE @SM TO @VM IN Y.ALL.DATA
    Y.BAL= Y.ARRAY<6>
    Y.CNT=1
    Y.PAY.LIMIT=Y.ARRAY<8>[7,2]:'/':Y.ARRAY<8>[5,2]:'/':Y.ARRAY<8>[1,4]
    Y.ACCT.BAL.DATE=Y.ARRAY<2>[7,2]:'/':Y.ARRAY<2>[5,2]:'/':Y.ARRAY<2>[1,4]
    Y.CARD.TYPE=Y.ARRAY<4>
*GD.TEST

    IF Y.MTH.CNT EQ Y.MTH THEN
        IF D.RANGE.AND.VALUE<Y.CUR.POS> EQ 1 THEN
            Y.ARRAY.HEAD.DOP="^^FD2=" : Y.ARRAY<13> : "^^FD3=" : Y.ARRAY<14> : "^^FD4=" : Y.ARRAY<15> : "^^FD5=" : Y.ARRAY<19> : "^^FD6=" : "RD$" : "^^FD7=" : Y.ARRAY<7> : "^^FD8=" : Y.ARRAY<9> : "^^FD9=" : Y.ARRAY<10> : "^^FD10=" : Y.ARRAY<6> : "^^FD11=" : Y.ARRAY<11> : "^^FD12=" : Y.ARRAY<12> : "^^FD13=" : Y.PAY.LIMIT : "^^FD14=" : CARD.NO : "^^FD15=" : Y.ACCT.BAL.DATE : "^^FD16=" : CARD.NO : "^^FD17=" : Y.ARRAY<9> : "^^FD18=" : Y.ARRAY<10> : "^^FD19=" : Y.ARRAY<17> : "^^FD20=" : Y.ARRAY<18> : "^^FD21=" : Y.ARRAY<11>: "^^FD22=" : Y.ARRAY<12> : "^^FD1="
        END
        ELSE
            Y.ARRAY.HEAD.USD="^^FDU2=" : Y.ARRAY<13> : "^^FDU3=" : Y.ARRAY<14> : "^^FDU4=" : Y.ARRAY<15> : "^^FDU5=" : Y.ARRAY<19> : "^^FDU6=" : "US$" : "^^FDU7=" : Y.ARRAY<7> : "^^FDU8=" : Y.ARRAY<9> : "^^FDU9=" : Y.ARRAY<10> : "^^FDU10=" : Y.ARRAY<6> : "^^FDU11=" : Y.ARRAY<11> : "^^FDU12=" : Y.ARRAY<12> : "^^FDU13=" : Y.PAY.LIMIT : "^^FDU14=" : CARD.NO : "^^FDU15=" : Y.ACCT.BAL.DATE : "^^FDU16=" : CARD.NO : "^^FDU17=" : Y.ARRAY<9> : "^^FDU23=" : Y.ACCT.BAL.DATE : "^^FDU18=" : Y.ARRAY<10> : "^^FDU19=" : Y.ARRAY<17> : "^^FDU20=" : Y.ARRAY<18> : "^^FDU21=" : Y.ARRAY<11>: "^^FDU22=" : Y.ARRAY<12> : "^^FDU1="
        END
    END
    LOOP
        REMOVE Y.DATA FROM Y.ALL.DATA SETTING Y.DATA.POS
        Y.BAL=Y.BAL-Y.ALL.DATA<Y.CNT,6>+Y.ALL.DATA<Y.CNT,5>
        Y.DB.TOT+=Y.ALL.DATA<Y.CNT,6>
        Y.CR.TOT+=Y.ALL.DATA<Y.CNT,5>
        Y.MSG.DESC=''
        Y.DATE.DATA=''
        Y.ALL.DATA<Y.CNT,1>=Y.ALL.DATA<Y.CNT,1>[1,4] :Y.ALL.DATA<Y.CNT,1>[6,2] :Y.ALL.DATA<Y.CNT,1>[9,2]
        Y.DATE.DATA=''
        Y.DATE.DATA=Y.ALL.DATA<Y.CNT,7>
*PACS00032454-S
        TRANSACT.YEAR=FIELD(Y.DATE.DATA,'-',1)
        TRANSACT.MONTH = FIELD(Y.DATE.DATA,'-',2)

*        IF TRANSACT.YEAR EQ CUR.YEAR AND TRANSACT.MONTH EQ CUR.MONTH THEN
        Y.ALL.DATA<Y.CNT,7>=Y.DATE.DATA[1,4] : Y.DATE.DATA[6,2] : Y.DATE.DATA[9,2]
        Y.FINAL.ARRAY<-1>=Y.MSG.DESC:'*':Y.ARRAY<2>:'*':Y.ARRAY<3>:'*':Y.ARRAY<4>:'*':Y.ARRAY<5>:'*':Y.ARRAY<6>:'*':Y.ARRAY<7>:'*':Y.ARRAY<8>:'*':Y.ARRAY<9>:'*':Y.ARRAY<10>:'*':Y.ARRAY<11>:'*':Y.ARRAY<12>:'*':Y.ARRAY<13>:'*':Y.ARRAY<14>:'*':Y.ARRAY<15>:'*':Y.ARRAY<16>:'*':Y.ARRAY<17>:'*':Y.ARRAY<18>:'*':Y.ARRAY<19>:'*':Y.ALL.DATA<Y.CNT,1>:'*':Y.ALL.DATA<Y.CNT,7>:'*':Y.ALL.DATA<Y.CNT,2>:'*':Y.ALL.DATA<Y.CNT,3>:'*':Y.ALL.DATA<Y.CNT,6>:'*':Y.ALL.DATA<Y.CNT,5>:'*':Y.BAL
        IF Y.ALL.DATA<Y.CNT,7> THEN
            Y.ALL.DATA<Y.CNT,7>=Y.ALL.DATA<Y.CNT,7>[7,2] :'/': Y.ALL.DATA<Y.CNT,7>[5,2]:'/' : Y.ALL.DATA<Y.CNT,7>[1,4]
        END
        IF Y.ALL.DATA<Y.CNT,1> THEN
            Y.ALL.DATA<Y.CNT,1>=Y.ALL.DATA<Y.CNT,1>[7,2] : '/':Y.ALL.DATA<Y.CNT,1>[5,2] :'/': Y.ALL.DATA<Y.CNT,1>[1,4]
        END
        IF D.RANGE.AND.VALUE<Y.CUR.POS> EQ 1 THEN
            Y.ARRAY.DATA.DOP=Y.ARRAY.DATA.DOP : Y.ALL.DATA<Y.CNT,1>: "#@#" : Y.ALL.DATA<Y.CNT,7> : "#@#" : Y.ALL.DATA<Y.CNT,3> : "#@#" : Y.ALL.DATA<Y.CNT,2> : "#@#" : Y.ALL.DATA<Y.CNT,6>: "#@#" : Y.ALL.DATA<Y.CNT,5> : "#^#"
        END
        ELSE
            Y.ARRAY.DATA.USD=Y.ARRAY.DATA.USD : Y.ALL.DATA<Y.CNT,1>: "#@#" : Y.ALL.DATA<Y.CNT,7> : "#@#" : Y.ALL.DATA<Y.CNT,3> : "#@#" : Y.ALL.DATA<Y.CNT,2> : "#@#" : Y.ALL.DATA<Y.CNT,6>: "#@#" : Y.ALL.DATA<Y.CNT,5> : "#^#"
        END

*        Y.HEADER.ARRAY=
*        Y.DATA.ARRAY  =
*        END
*PACS00032454-E
        Y.CNT += 1
    WHILE Y.CNT LE Y.ROWS
    REPEAT
    IF D.RANGE.AND.VALUE<Y.CUR.POS> EQ 1 THEN
        Y.ARRAY.TOT.DOP="^^FDDT1=" : Y.DB.TOT : "^^FDDT2=" : Y.CR.TOT
    END
    ELSE
        Y.ARRAY.TOT.USD="^^FDUT1=" : Y.DB.TOT : "^^FDUT2=" : Y.CR.TOT
    END
RETURN
*--------
SET.VARS:
*--------

    Y.CALC.REG.INT = Y.ARRAY<20>
    Y.BILL.REG.INT = Y.ARRAY<21>
    Y.REG.INT.RATE = Y.ARRAY<22>
    Y.LAST.AVG.BAL = Y.ARRAY<23>
    Y.PERD.AVG.BAL = Y.ARRAY<24>
    Y.MSG.ST = '' ;*R22 Manual Conversion
    Y.OFF = '' ;*R22 Manual Conversion
    Y.INT.REG.DETS = "^^FD28=" : Y.CALC.REG.INT : "^^FD29=" : Y.BILL.REG.INT :"^^FD30=" : Y.REG.INT.RATE : "^^FD31=" : Y.LAST.AVG.BAL : "^^FD32=" : Y.PERD.AVG.BAL
    Y.NAME          =Y.ARRAY<3>
    Y.ARRAY.HEAD.DOP="^^FD23=" : Y.NAME : "^^FD24=" : Y.DIRECCION :"^^FD25=" : Y.OFF : "^^FD26=" : Y.MSG.ST : "^^FD27=" : Y.CARD.TYPE : Y.INT.REG.DETS : Y.ARRAY.TOT.DOP : Y.ARRAY.HEAD.DOP
    Y.ARRAY.HEAD.USD=Y.ARRAY.TOT.USD : Y.ARRAY.HEAD.USD
    CALL System.setVariable("CURRENT.SCA.PDF.HEADER.DOP",Y.ARRAY.HEAD.DOP)
    CALL System.setVariable("CURRENT.SCA.PDF.DATA.DOP",Y.ARRAY.DATA.DOP)
    CALL System.setVariable("CURRENT.SCA.PDF.HEADER.USD",Y.ARRAY.HEAD.USD)
    CALL System.setVariable("CURRENT.SCA.PDF.DATA.USD",Y.ARRAY.DATA.USD)
    IF NOT(Y.FINAL.ARRAY) THEN
        ENQ.ERROR="No Transactions available for this Period"
    END
RETURN
END
