* @ValidationCode : Mjo5ODE4MDc3OTk6VVRGLTg6MTY4NDIyMjgyNDk2MzpJVFNTOi0xOi0xOjEwMToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:24
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 101
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.LIST.AFFI.FOR.INDIV(CUSTOMER.ID)
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This is an batch routine used to process the records from CUSTOMER file with required
**                        selection and generate report in the parameterized out folder
*
* Developed By          : Shiva Prasad Y, Capgemini
*
* Development Reference : 786892-218-MV33
*
* Attached To           : Batch - BNK/REDO.B.LIST.AFFI.FOR.INDIV
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
** 24-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 24-04-2023 Skanda R22 Manual Conversion -Call method format changed
*-----------------------------------------------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;* R22 Auto conversion
    $INSERT I_EQUATE ;* R22 Auto conversion
    $INSERT I_F.RELATION.CUSTOMER ;* R22 Auto conversion
    $INSERT I_F.CUSTOMER ;* R22 Auto conversion
    $INSERT I_F.COMPANY ;* R22 Auto conversion
    $INSERT I_REDO.B.LIST.AFFI.FOR.INDIV.COMMON ;* R22 Auto conversion
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON ;* R22 Auto conversion
    $USING APAP.REDOCHNLS
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**

    GOSUB INIT.PARA
    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
INIT.PARA:
*************
    C$SPARE(451)=''

RETURN
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
    RELATION.CUSTOMER.ID = CUSTOMER.ID
    GOSUB READ.RELATION.CUSTOMER

    IF NOT(R.RELATION.CUSTOMER) THEN
        GOSUB RAISE.FATAL.ERROR
    END

    FL.CUSTOMER.ID  = CUSTOMER.ID
    FL.REL.CODES    = R.RELATION.CUSTOMER<EB.RCU.IS.RELATION>
    FL.REL.CUSTOMER = R.RELATION.CUSTOMER<EB.RCU.OF.CUSTOMER>
    Y.APAP.MGMT=''
    FL.REL.CODES.COUNT = DCOUNT(FL.REL.CODES,@VM)
    FL.REL.CODES.INIT  = 1
    LOOP
    WHILE FL.REL.CODES.INIT LE FL.REL.CODES.COUNT
        LOCATE FL.REL.CODES<1,FL.REL.CODES.INIT> IN FL.PARAM.SEL.CODES<1,1,1> SETTING FL.FOUND.POS THEN
            IF Y.APAP.CUST.NO EQ FL.REL.CUSTOMER<1,FL.REL.CODES.INIT> THEN
                Y.APAP.MGMT='1'
                GOSUB PROCESS.MAIN.CUS.ID
                FL.REL.CODES.INIT=FL.REL.CODES.COUNT
            END
        END
        FL.REL.CODES.INIT += 1
    REPEAT

    IF Y.APAP.MGMT THEN
        CUSTOMER.ID=FL.CUSTOMER.ID
        GOSUB READ.CUSTOMER
        R.CUSTOMER.AP.MT  =R.CUSTOMER
        SL.REL.CODES      =R.CUSTOMER.AP.MT<EB.CUS.RELATION.CODE>
        SL.REL.CUSTOMER   =R.CUSTOMER.AP.MT<EB.CUS.REL.CUSTOMER>
        SL.REL.CODES.COUNT=DCOUNT(SL.REL.CODES,@VM)
        SL.REL.CODES.INIT =1
        LOOP
        WHILE SL.REL.CODES.INIT LE SL.REL.CODES.COUNT
            LOCATE SL.REL.CODES<1,SL.REL.CODES.INIT> IN SL.PARAM.SEL.CODES<1,1,1> SETTING Y.SL.CUST.POS THEN
                SL.CUSTOMER.ID=SL.REL.CUSTOMER<1,SL.REL.CODES.INIT>
                C$SPARE(453)  =''; C$SPARE(454)  =''; C$SPARE(455)  =''; C$SPARE(456)  =''; C$SPARE(457)  =''
                GOSUB FORM.SPARE.ARRAY
            END
            SL.REL.CODES.INIT += 1
        REPEAT
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
FORM.SPARE.ARRAY:
*****************
* In this para of the program, the CSPARE array is formed
**
    CUSTOMER.ID = SL.CUSTOMER.ID
    GOSUB READ.CUSTOMER

    SL.CUS.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    SL.CUS.LEGAL  = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    SL.CUS.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>

    IF SL.CUS.CIDENT THEN
        SL.CUS.CIDENT = FMT(SL.CUS.CIDENT,"R(###-#######-#)")
        C$SPARE(453)  = SL.CUS.CIDENT
    END ELSE
        C$SPARE(453) = SL.CUS.NATION:SL.CUS.LEGAL
    END

    PRODUCT.GROUP = ''; REL.CODE      = ''
    APAP.LAPAP.redoSRegCustomerExtract(SL.CUSTOMER.ID,PRODUCT.GROUP,REL.CODE,OUT.ARR) ;*R22 Manual Conversion

    C$SPARE(454) = OUT.ARR<2>

    CUS.GIVEN.NAME  = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
    CUS.FAMILY.NAME = R.CUSTOMER<EB.CUS.FAMILY.NAME>

    C$SPARE(455) = CUS.GIVEN.NAME
    C$SPARE(456) = CUS.FAMILY.NAME

    DISPLAY.CODE = SL.PARAM.DISP.CODES<1,1,Y.SL.CUST.POS>
    C$SPARE(457) = DISPLAY.CODE

*    IF NOT(CUSTOMER.REPORTED) THEN
    C$SPARE(452) = Y.REL.REP
*    END
    GOSUB MAP.RCL.RECORD
RETURN
*-----------------------------------------------------------------------------------------------------------------
********************
PROCESS.MAIN.CUS.ID:
********************
* In this para of the program, the main customer is processed
**
    CUSTOMER.ID = FL.CUSTOMER.ID
    GOSUB READ.CUSTOMER

    CUS.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    CUS.LEGAL  = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    CUS.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>

    IF CUS.CIDENT THEN
        CUS.CIDENT   = FMT(CUS.CIDENT,"R(###-#######-#)")
        C$SPARE(451) = CUS.CIDENT
    END ELSE
        C$SPARE(451) = CUS.NATION:CUS.LEGAL
    END
RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
MAP.RCL.RECORD:
***************
* In this para of the program, the CONDUIT.LINEAR values are fecthed and mapped
**
    MAP.FMT   = 'MAP'
    ID.RCON.L = "REDO.RCL.MV33"
    APP       = FN.CUSTOMER
    R.APP     = R.CUSTOMER
    ID.APP    = CUSTOMER.ID

    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    OUT.ARRAY = R.RETURN.MSG

    IF OUT.ARRAY THEN
        GOSUB WRITE.TO.FILE
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
**************
WRITE.TO.FILE:
**************
* In this para of the program, the final array is written to the file
**
    WRITESEQ OUT.ARRAY APPEND TO SEQ.PTR ELSE
        ERR.MSG  = "Unable to write to file '":FILE.NAME:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'ONLINE'
        MON.TP   = 04
        REC.CON  = 'MV33-':ERR.MSG
        DESC     = 'MV33-':ERR.MSG
        APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC) ;*R22 Manual Conversion
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
RAISE.FATAL.ERROR:
******************
* In this para of the program, the FATAL.ERROR is called
**
    MESSAGE.INFO = ''         ;* Handling Fatal error to halt the process
    MESSAGE.INFO<1> = 'REDO.B.LIST.AFFI.FOR.INDIV'
    MESSAGE.INFO<2> = CUSTOMER.ID
    MESSAGE.INFO<3> = 'BUILD.LIST'
    MESSAGE.INFO<4> = 'Record not received'
    MESSAGE.INFO<5> = 'YES'
    TEXT = ''
    CALL FATAL.ERROR(MESSAGE.INFO)

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
