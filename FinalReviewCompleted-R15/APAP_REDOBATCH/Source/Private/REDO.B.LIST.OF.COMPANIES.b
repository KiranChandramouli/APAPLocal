* @ValidationCode : MjotMTU0MzIxOTU2MzpDcDEyNTI6MTY4NDg1NDM4OTMwNjpJVFNTOi0xOi0xOjEwOToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 109
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LIST.OF.COMPANIES(CUSTOMER.ID)
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine the report which contains companies where Directors and Officers have 10% or more share
*
* Developed By          : Mayurika Tiwary, Capgemini
*
* Development Reference : MV31
*
* Attached To           : Batch - BNK/REDO.B.LIST.OF.COMPANIES
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
* MV31                   Mayurika Tiwary                 2014-02-14           Initial Draft
*                        Rashmitha M                     2014-03-14           Company Id and company name displayed
*                                                                             as per the required format
* Date                   who                   Reference              
* 11-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - SM TO @SM AND VM TO @VM
* 11-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COMPANY
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.LIST.OF.COMPANIES.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts.
**

    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
INIT.PARA:
**************

    C$SPARE(451)=''
    C$SPARE(452)=''
    C$SPARE(453)=''
    C$SPARE(454)=''
    C$SPARE(455)=''
    C$SPARE(456)=''
    C$SPARE(457)=''

RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts and the relation codes are defined for Customer.
**
*    RELATION.CUSTOMER.ID = CUSTOMER.ID
    FL.CUSTOMER.ID = CUSTOMER.ID
    Y.REL.WITH.AP.COD=''
    Y.APAP.MGMT=''
*    CALL F.READ(FN.RELATION.CUSTOMER,RELATION.CUSTOMER.ID,R.RELATION.CUSTOMER,F.RELATION.CUSTOMER,CUS.ERR)
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER.AP.MT,F.CUSTOMER,Y.AP.MT.ERR)
    IF NOT(Y.AP.MT.ERR) THEN
        FL.REL.CODES       = R.CUSTOMER.AP.MT<EB.CUS.RELATION.CODE>
        FL.REL.CUSTOMER    = R.CUSTOMER.AP.MT<EB.CUS.REL.CUSTOMER>
        FL.REL.CODES.COUNT = DCOUNT(FL.REL.CODES,@VM)
        FL.REL.CODES.INIT  = 1
        LOOP
        WHILE FL.REL.CODES.INIT LE FL.REL.CODES.COUNT
            LOCATE FL.REL.CODES<1,FL.REL.CODES.INIT> IN FL.PARAM.SEL.CODES<1,1,1> SETTING Y.FL.CUST.POS THEN
                IF Y.APAP.CUST.NO EQ FL.REL.CUSTOMER<1,FL.REL.CODES.INIT> THEN
                    Y.APAP.MGMT      =FL.REL.CODES<1,FL.REL.CODES.INIT>
                    Y.REL.WITH.AP.COD=FL.PARAM.DISP.CODES<1,1,Y.FL.CUST.POS>
                    FL.REL.CODES.INIT=FL.REL.CODES.COUNT
                END
            END
            FL.REL.CODES.INIT += 1
        REPEAT
    END
    IF Y.APAP.MGMT THEN
        SL.REL.CODES      =R.CUSTOMER.AP.MT<EB.CUS.RELATION.CODE>
        SL.REL.CUSTOMER   =R.CUSTOMER.AP.MT<EB.CUS.REL.CUSTOMER>
        SL.REL.CODES.COUNT=DCOUNT(SL.REL.CODES,@VM)
        SL.REL.CODES.INIT =1
        LOOP
        WHILE SL.REL.CODES.INIT LE SL.REL.CODES.COUNT
            LOCATE SL.REL.CODES<1,SL.REL.CODES.INIT> IN SL.PARAM.SEL.CODES<1,1,1> SETTING Y.SL.CUST.POS THEN
                SL.CUSTOMER.ID=SL.REL.CUSTOMER<1,SL.REL.CODES.INIT>
                GOSUB INIT.PARA
                C$SPARE(456)=Y.REL.WITH.AP.COD
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
* In this para of the program, the customer is checked in earlier reports.
**
    CALL F.READ(FN.CUSTOMER,SL.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTO.ERR)

    GOSUB UPDATE.CSPARE.VARIABLE

    CUS.ROLE.INFO.COUNT = DCOUNT(CUS.ROLE.INFO.VALUE,@SM)
    CUS.ROLE.COUNT = DCOUNT(CUS.ROLE.VALUE,@SM)

    IF CUS.ROLE.INFO.COUNT GE CUS.ROLE.COUNT THEN
        LOOP.COUNT = CUS.ROLE.INFO.COUNT
    END ELSE
        LOOP.COUNT = CUS.ROLE.COUNT
    END
    IF NOT(LOOP.COUNT) THEN
        LOOP.COUNT = 1
    END

    LOOP.INIT = 1
    LOOP
    WHILE LOOP.INIT LE LOOP.COUNT
        GOSUB LOOP.THRU.ROLES
        LOOP.INIT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------------
***********************
UPDATE.CSPARE.VARIABLE:
***********************
* In this para of the program, the variable C$SPARE is assigned with values.
**
    PRODUCT.GROUP = ''
    REL.CODE = ''
*    CALL REDO.S.REP.CUSTOMER.EXTRACT(FL.CUSTOMER.ID,PRODUCT.GROUP,REL.CODE,OUT.ARR)

    R.CUS.APP.CALL=R.CUSTOMER
    CALL DR.REG.GET.CUST.TYPE(R.CUS.APP.CALL,'',Y.CUST.TYPE,'')

    C$SPARE(451)= Y.CUST.TYPE
    CUS.RNC     = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    CUS.FOREIGN = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>
    CUS.NATION  = R.CUSTOMER<EB.CUS.NATIONALITY>

    IF CUS.NATION EQ 'DO' THEN
*20140319 (S)
        IF CUS.RNC THEN
            C$SPARE(452) = FMT(CUS.RNC,"R(#-##-#####-#)")
        END ELSE
            C$SPARE(452) = ''
        END
*20140319 (E)
    END ELSE
        C$SPARE(452) = CUS.NATION:CUS.FOREIGN
    END

    CUS.NAME.1 = R.CUSTOMER<EB.CUS.NAME.1,R.COMPANY(EB.COM.LANGUAGE.CODE)>
    CUS.NAME.2 = R.CUSTOMER<EB.CUS.NAME.2,R.COMPANY(EB.COM.LANGUAGE.CODE)>
*20140319 (S)
    IF NOT(CUS.NAME.1) THEN
        CUS.NAME.1=R.CUSTOMER<EB.CUS.NAME.1,1>
    END

    IF NOT(CUS.NAME.2) THEN
        CUS.NAME.2=R.CUSTOMER<EB.CUS.NAME.2,1>
    END
*20140319 (E)
    C$SPARE(453) = CUS.NAME.1 :' ': CUS.NAME.2


    CUS.ROLE.INFO.VALUE = R.CUSTOMER.AP.MT<EB.CUS.ROLE.MORE.INFO,SL.REL.CODES.INIT>
    CUS.ROLE.VALUE      = R.CUSTOMER.AP.MT<EB.CUS.ROLE,SL.REL.CODES.INIT>

    GOSUB PROCESS.FL.REL.CUS.ID

RETURN
*-----------------------------------------------------------------------------------------------------------------
**********************
PROCESS.FL.REL.CUS.ID:
**********************
* In this para of the program, the variable C$SPARE is checked.

    FL.CUS.NATION = R.CUSTOMER.AP.MT<EB.CUS.NATIONALITY>
    FL.CUS.LEGAL  = R.CUSTOMER.AP.MT<EB.CUS.LEGAL.ID,1>
    FL.CUS.CIDENT = R.CUSTOMER.AP.MT<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    FL.CUS.FOREIGN= R.CUSTOMER.AP.MT<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>
    FL.CUS.RNC    = R.CUSTOMER.AP.MT<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    IF FL.CUS.CIDENT THEN
        C$SPARE(457) =FMT(FL.CUS.CIDENT,"R(###-#######-#)")
    END ELSE
        IF FL.CUS.RNC THEN
            C$SPARE(457) = FL.CUS.RNC
        END
        ELSE
            IF FL.CUS.LEGAL THEN
                C$SPARE(457) = FL.CUS.NATION:FL.CUS.LEGAL
            END
            ELSE
                IF FL.CUS.FOREIGN THEN
                    C$SPARE(457) = FL.CUS.NATION:FL.CUS.FOREIGN
                END
            END
        END
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
****************
LOOP.THRU.ROLES:
****************
* In this para of the program, the ROLE values are taken and C$SPARE is updated.
**
    IF CUS.ROLE.INFO.VALUE<1,1,LOOP.INIT> GE 10 THEN
        C$SPARE(454) = CUS.ROLE.INFO.VALUE<1,1,LOOP.INIT>
    END ELSE
        RETURN
    END

    C$SPARE(455) = FMT(CUS.ROLE.VALUE<1,1,LOOP.INIT>,'R%2')

    GOSUB MAP.RCL.RECORD

RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
MAP.RCL.RECORD:
***************
* In this para of the program, the CONDUIT.LINEAR values are fecthed.
**
    MAP.FMT = 'MAP'
    ID.RCON.L = BATCH.DETAILS<3,1,2>
    APP = FN.CUSTOMER
    ID.APP = CUSTOMER.ID
    R.APP = R.CUSTOMER

    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    OUT.ARRAY = R.RETURN.MSG

    GOSUB WRITE.TO.FILE

RETURN
*-----------------------------------------------------------------------------------------------------------------
**************
WRITE.TO.FILE:
**************
* In this para of the program, the final array is written to the file.
**
    WRITESEQ OUT.ARRAY APPEND TO SEQ.PTR ELSE
        ERR.MSG = "UNABLE TO WRITE TO FILE '":FILE.NAME:"'"
        INT.CODE = 'REP001'
        INT.TYPE = 'ONLINE'
        MON.TP = 04
        REC.CON = 'MV31-':ERR.MSG
        DESC = 'MV31-':ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------------------------
END       ;*End of program
