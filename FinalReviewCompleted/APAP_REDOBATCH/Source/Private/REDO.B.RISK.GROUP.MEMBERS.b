* @ValidationCode : MjoxMjAwMDgyNDUxOkNwMTI1MjoxNjkwMjY0NDM3ODQ0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:23:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.RISK.GROUP.MEMBERS(CUSTOMER.ID)
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN4-GR03
*
* Attached To           : Batch - BNK/REDO.B.RISK.GROUP.MEMBERS
*
* Attached As           : Multi Threaded Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : CUSTOMER.ID - Contains the Customer Number
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#2 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* REGN4-GR03             Kalyani L K                     2014-02-14           Initial Draft
*                        Thenmalar T                     2014-03-18           Fixes done as per the changes suggested
*                        Thenmalar T                     2014-03-19           Fixes done as per the changes suggested
* Date                   who                   Reference
* 13-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND ++ TO += 1 AND SESSION.NO TO AGENT.NUMBER AND ADD I_TSA.COMMON
* 13-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_TSA.COMMON   ;*R22 AUTO CONVERSTION ADD I_TSA.COMMON
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CUST.DOCUMENT
    $INSERT I_F.COMPANY
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.RISK.GROUP.MEMBERS.COMMON
    $USING APAP.REDOCHNLS
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**

    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    RELATION.CUSTOMER.ID = CUSTOMER.ID
    GOSUB READ.RELATION.CUSTOMER

    GOSUB READ.CUSTOMER

    FL.CUSTOMER.ID = CUSTOMER.ID
    R.FL.CUSTOMER  = R.CUSTOMER

    IF NOT(R.CUSTOMER) THEN
        GOSUB CHECK.FATAL.ERROR
    END

    IF NOT(R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS>) THEN
        RETURN
    END
    Y.RGRC.ID='GR03':TODAY:AGENT.NUMBER  ;*R22 AUTO CONVERSTION SESSION.NO TO AGENT.NUMBER
    CALL F.READ(FN.REDO.GR.REP.CUST,Y.RGRC.ID,R.REDO.GR.REP.CUST,F.REDO.GR.REP.CUST,Y.RGRC.ERR)
    GOSUB CHECK.RELATION.CODES
    CALL F.WRITE(FN.REDO.GR.REP.CUST,Y.RGRC.ID,R.REDO.GR.REP.CUST)
RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.FL.CSPARE.VALUES:
*********************
* In this para of the program, the variable C$SPARE is assigned with values
**
    CUS.GRP.RIESGO = R.FL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS>
    CHANGE @SM TO @FM IN CUS.GRP.RIESGO
    Y.RIESGO.TOT   = DCOUNT(CUS.GRP.RIESGO,@FM)

    Y.RIESGO.CNT=1
    LOOP
    WHILE Y.RIESGO.CNT LE Y.RIESGO.TOT
        C$SPARE(451)   = CUS.GRP.RIESGO<Y.RIESGO.CNT>[7]
        Y.ID =CUS.GRP.RIESGO<Y.RIESGO.CNT>[7]:'*':SL.CUSTOMER.ID:'*':Y.TL.CUSTOMER.ID
        LOCATE Y.ID IN Y.GR03.REP.LIST SETTING POS ELSE
            R.REDO.GR.REP.CUST<-1>=Y.ID
            GOSUB MAP.RCL.REC
        END
        Y.RIESGO.CNT += 1
    REPEAT
RETURN
********************
GET.TL.CSPARE.VALUES:
********************
*20140319(S)
    LANG.CODE      = R.COMPANY(EB.COM.LANGUAGE.CODE)
    CUSTOMER.ID=Y.TL.CUSTOMER.ID
    GOSUB READ.CUSTOMER
    R.TL.CUSTOMER=R.CUSTOMER
    IF (R.TL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.GRP.RIESGO.POS>) THEN
        RETURN
    END

    Y.CU.RNC = R.TL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    IF Y.CU.RNC NE '' THEN
        Y.CU.RNC.VAL = FMT(Y.CU.RNC,"R(#-##-#####-#)")
    END ELSE
        Y.CU.RNC.VAL = ''
    END
    C$SPARE(454) = Y.CU.RNC.VAL

    IF R.TL.CUSTOMER<EB.CUS.NAME.1,LANG.CODE> EQ '' THEN
        Y.NAME.1 = R.TL.CUSTOMER<EB.CUS.NAME.1,1>
    END ELSE
        Y.NAME.1 = R.TL.CUSTOMER<EB.CUS.NAME.1,LANG.CODE>
    END

    IF R.TL.CUSTOMER<EB.CUS.NAME.2,LANG.CODE> EQ '' THEN
        Y.NAME.2 = R.TL.CUSTOMER<EB.CUS.NAME.2,1>
    END ELSE
        Y.NAME.2 = R.TL.CUSTOMER<EB.CUS.NAME.2,LANG.CODE>
    END

    Y.LANG.NAME = Y.NAME.1:' ':Y.NAME.2
    C$SPARE(455) = Y.LANG.NAME
*20140319(E)

    APAP.IND     = R.TL.CUSTOMER<EB.CUS.LOCAL.REF,L.APAP.INDUSTRY.POS>[1,2]

    C$SPARE(457) = APAP.IND

    LOCATE APAP.IND IN FIELD.IND.VAL<1> SETTING IND.POS THEN
        C$SPARE(459) = FIELD.IND.DISP<IND.POS>
    END ELSE
        C$SPARE(459) = 'N'
    END

    C$SPARE(458) = R.TL.CUSTOMER<EB.CUS.EMPLOYMENT.STATUS,1>

    CUST.DOCUMENT.ID = Y.TL.CUSTOMER.ID :'*': FIELD.DOC.VAL
    GOSUB READ.CUST.DOCUMENT

    IF NOT(R.CUST.DOCUMENT<CUS.DOC.END.DATE>) THEN
        C$SPARE(461) = ''
    END ELSE
*20140318(S)
        Y.DOC.END.DATE = R.CUST.DOCUMENT<CUS.DOC.END.DATE>
        Y.DOC.END.DATE = ICONV(Y.DOC.END.DATE,'D')
        Y.DOC.END.DATE = OCONV(Y.DOC.END.DATE,'D4/E')

        C$SPARE(461) = Y.DOC.END.DATE
*20140318(E)

    END
    GOSUB GET.FL.CSPARE.VALUES
RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
CHECK.RELATION.CODES:
*********************
* In this para of the program, the relation codes defined for Customer are checked
**

    PRM.REV.COUNT = DCOUNT(R.RELATION.CUSTOMER<EB.RCU.IS.RELATION>,@VM)
    PRM.REV.INIT  = 1

    LOOP
    WHILE PRM.REV.INIT LE PRM.REV.COUNT
        LOCATE R.RELATION.CUSTOMER<EB.RCU.IS.RELATION,PRM.REV.INIT> IN FIELD.REV.VAL<1> SETTING REL.CODE.POS THEN
            SL.CUSTOMER.ID = R.RELATION.CUSTOMER<EB.RCU.OF.CUSTOMER,PRM.REV.INIT>
            GOSUB GET.SL.CUST.VALUES
        END
        PRM.REV.INIT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------------
*******************
GET.SL.CUST.VALUES:
*******************
* In this para of the program, the second level customer details are fetched
**
    CUSTOMER.ID = SL.CUSTOMER.ID
    GOSUB READ.CUSTOMER

    R.SL.CUSTOMER = R.CUSTOMER
    PRM.REL.COUNT = DCOUNT(R.SL.CUSTOMER<EB.CUS.RELATION.CODE>,@VM)
    PRM.REL.INIT  =1
    LOOP
    WHILE PRM.REL.INIT LE PRM.REL.COUNT
        LOCATE R.SL.CUSTOMER<EB.CUS.RELATION.CODE,PRM.REL.INIT> IN FIELD.REL.VAL SETTING REL.INIT THEN
            IF R.SL.CUSTOMER<EB.CUS.REL.CUSTOMER,PRM.REL.INIT> EQ FL.CUSTOMER.ID THEN

                IF R.SL.CUSTOMER<EB.CUS.ROLE.MORE.INFO,PRM.REL.INIT,1> GT 10 THEN
                    GOSUB GET.SL.CSPARE.VALUES
                    GOSUB GET.TL.VALUES
                END
            END
        END
        PRM.REL.INIT += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
GET.TL.VALUES:
**************
* In this para of the program, the customer is checked in earlier reports
**

    Y.TL.REL.COUNT = DCOUNT(R.SL.CUSTOMER<EB.CUS.RELATION.CODE>,@VM)
    Y.TL.REL.INIT  =1
    LOOP
    WHILE Y.TL.REL.INIT LE Y.TL.REL.COUNT
        LOCATE R.SL.CUSTOMER<EB.CUS.RELATION.CODE,Y.TL.REL.INIT> IN FIELD.REL.VAL SETTING REL.INIT THEN
            IF R.SL.CUSTOMER<EB.CUS.REL.CUSTOMER,Y.TL.REL.INIT> NE FL.CUSTOMER.ID THEN
                IF R.SL.CUSTOMER<EB.CUS.ROLE.MORE.INFO,Y.TL.REL.INIT,1> GT 10 THEN
                    C$SPARE(456) = R.SL.CUSTOMER<EB.CUS.ROLE.MORE.INFO,Y.TL.REL.INIT,1>
                    C$SPARE(460) = ''
                    LOCATE R.SL.CUSTOMER<EB.CUS.ROLE.MORE.INFO,Y.TL.REL.INIT,1> IN FIELD.ROLE.VAL<1> SETTING ROLE.POS THEN
                        C$SPARE(460) = FIELD.ROLE.DISP<ROLE.POS>
                    END
                    C$SPARE(452) = FIELD.GR.VAL
                    Y.TL.CUSTOMER.ID=R.SL.CUSTOMER<EB.CUS.REL.CUSTOMER,Y.TL.REL.INIT>
                    GOSUB GET.TL.CSPARE.VALUES
                END
            END
        END
        Y.TL.REL.INIT += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------------------------------------------
*********************
GET.SL.CSPARE.VALUES:
*********************
* In this para of the program, the variable C$SPARE is assigned with values
**
    C$SPARE(453) = ''

    BEGIN CASE
        CASE R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS> NE ''
            Y.CU.CIDENT = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
            Y.CU.CIDENT.VAL = FMT(Y.CU.CIDENT,"R(###-#######-#)")
            C$SPARE(453) = Y.CU.CIDENT.VAL

        CASE R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS> NE ''
            Y.SL.CU.RNC = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
            Y.SL.CU.RNC.VAL = FMT(Y.SL.CU.RNC,"R(#-##-#####-#)")
            C$SPARE(453) = Y.SL.CU.RNC.VAL

        CASE R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS> NE ''
            C$SPARE(453) = R.SL.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>

        CASE 1
            C$SPARE(453) = R.SL.CUSTOMER<EB.CUS.NATIONALITY> : R.SL.CUSTOMER<EB.CUS.LEGAL.ID,1>

    END CASE

RETURN
*-----------------------------------------------------------------------------------------------------------------
************
MAP.RCL.REC:
************
* In this para of the program, the CONDUIT.LINEAR values are fecthed
**
    MAP.FMT = "MAP"
    ID.RCON.L = BATCH.DETAILS<3,1,2>
    APP = FN.CUSTOMER
    R.APP = R.FL.CUSTOMER
    ID.APP = FL.CUSTOMER.ID

    CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT, ID.RCON.L, APP, ID.APP, R.APP,R.RETURN.MSG,ERR.MSG)

    FINAL.ARRAY = R.RETURN.MSG

    IF FINAL.ARRAY THEN
        GOSUB WRITE.FILE
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
***********************
READ.RELATION.CUSTOMER:
***********************
* In this para of the program, file RELATION.CUSTOMER is read
**
    R.RELATION.CUSTOMER  = ''
    RELATION.CUSTOMER.ER = ''
    CALL F.READ(FN.RELATION.CUSTOMER,RELATION.CUSTOMER.ID,R.RELATION.CUSTOMER,F.RELATION.CUSTOMER,RELATION.CUSTOMER.ER)

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
READ.CUSTOMER:
**************
* In this para of the program, file CUSTOMER is read
**
    R.CUSTOMER  = ''
    CUSTOMER.ER = ''
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)

RETURN
*-----------------------------------------------------------------------------------------------------------------
*******************
READ.CUST.DOCUMENT:
*******************
* In this para of the program, file CUST.DOCUMENT is read
**
    R.CUST.DOCUMENT  = ''
    CUST.DOCUMENT.ER = ''
    CALL F.READ(FN.CUST.DOCUMENT,CUST.DOCUMENT.ID,R.CUST.DOCUMENT,F.CUST.DOCUMENT,CUST.DOCUMENT.ER)

RETURN
*-----------------------------------------------------------------------------------------------------------------
***********
WRITE.FILE:
***********
* In this para of the program, the final array is written to the file
**
    WRITESEQ FINAL.ARRAY APPEND TO SEQ.PTR ELSE
        INT.CODE = "REP001"
        INT.TYPE = "ONLINE"
        MON.TP   = 04
        REC.CON  = "GR03"
        DESC     = "GR03"
*       CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Code Conversion
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
CHECK.FATAL.ERROR:
******************
* In this para of the program, the FATAL.ERROR is called
**
    MESSAGE.INFO = '' ;* Handling Fatal error to halt the process
    MESSAGE.INFO<1> = 'REDO.B.RISK.GROUP.MEMBERS'
    MESSAGE.INFO<2> = CUSTOMER.ID
    MESSAGE.INFO<3> = 'BUILD.LIST'
    MESSAGE.INFO<4> = 'Record not received'
    MESSAGE.INFO<5> = 'YES'
    TEXT = ''
    CALL FATAL.ERROR(MESSAGE.INFO)

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
