SUBROUTINE REDO.B.LIST.OF.SHAREHOLDER(CUSTOMER.ID)
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This is an batch routine used to process the records from CUSTOMER file with required
**                        selection and generate report in the parameterized out folder
*
* Developed By          : Shiva Prasad Y, Capgemini
*
* Development Reference : 786922-217-MV32
*
* Attached To           : Batch - BNK/REDO.B.LIST.OF.SHAREHOLDER
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
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COMPANY
    $INSERT I_REDO.B.LIST.OF.SHAREHOLDER.COMMON
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
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
                    Y.APAP.MGMT =FL.REL.CODES<1,FL.REL.CODES.INIT>
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
                CUS.AT.ROLE.INFO.VALUE = R.CUSTOMER.AP.MT<EB.CUS.ROLE.MORE.INFO,SL.REL.CODES.INIT>
                CUS.AT.ROLE.INFO.COUNT = DCOUNT(CUS.AT.ROLE.INFO.VALUE,@SM)
                LOOP.INIT = 1
                LOOP
                WHILE LOOP.INIT LE CUS.AT.ROLE.INFO.COUNT
                    IF CUS.AT.ROLE.INFO.VALUE<1,1,LOOP.INIT> GE 10 THEN
                        GOSUB THIRD.LEVEL.FILTER
                        LOOP.INIT=CUS.AT.ROLE.INFO.COUNT
                    END
                    LOOP.INIT += 1
                REPEAT
            END
            SL.REL.CODES.INIT += 1
        REPEAT
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
********************
THIRD.LEVEL.FILTER:
********************
* In this para of the program, the second level selection is executed to filter the final records to be displayed
**

    RELATION.CUSTOMER.ID = SL.CUSTOMER.ID
    GOSUB READ.RELATION.CUSTOMER

    IF NOT(R.RELATION.CUSTOMER) THEN
        GOSUB RAISE.FATAL.ERROR
    END

    TL.REL.CODES       = R.RELATION.CUSTOMER<EB.RCU.IS.RELATION>
    TL.REL.CUSTOMER    = R.RELATION.CUSTOMER<EB.RCU.OF.CUSTOMER>
    TL.REL.CODES.COUNT = DCOUNT(TL.REL.CODES,@VM)
    TL.REL.CODES.INIT  = 1
    GOSUB GET.COMPANY.REG
    LOOP
    WHILE TL.REL.CODES.INIT LE TL.REL.CODES.COUNT
        LOCATE TL.REL.CODES<1,TL.REL.CODES.INIT> IN TL.PARAM.SEL.CODES<1,1,1> SETTING TL.FOUND.POS THEN
            TL.CUSTOMER.ID=TL.REL.CUSTOMER<1,TL.REL.CODES.INIT>
            GOSUB FORM.SPARE.ARRAY
        END
        TL.REL.CODES.INIT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------------------------------------
*****************
GET.COMPANY.REG:
*****************
* In this para of the program, the CSPARE array is formed
**
    CUSTOMER.ID = SL.CUSTOMER.ID
    GOSUB READ.CUSTOMER
    C$SPARE(451)=''
    CUS.RNC     = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    CUS.FOREIGN = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>
    CUS.NATION  = R.CUSTOMER<EB.CUS.NATIONALITY>

    IF CUS.NATION EQ 'DO' THEN
        CUS.RNC      = FMT(CUS.RNC,"R(#-##-#####-#)")
        C$SPARE(451) = CUS.RNC
    END ELSE
        C$SPARE(451) = CUS.NATION:CUS.FOREIGN
    END

RETURN


*---------------
FORM.SPARE.ARRAY:
*---------------
*        DISPLAY.CODE = FL.PARAM.DISP.CODES<1,1,FL.FOUND.POS>
*        C$SPARE(458) = DISPLAY.CODE

*        LOCATE FL.REL.CODES<1,FL.REL.CODES.INIT> IN R.CUSTOMER<EB.CUS.RELATION.CODE,1> SETTING FL.CUS.FOUND.POS THEN
*            CUS.ROLE.INFO.VALUE = R.CUSTOMER<EB.CUS.ROLE.MORE.INFO,FL.CUS.FOUND.POS>
*            CUS.ROLE.VALUE      = R.CUSTOMER<EB.CUS.ROLE,FL.CUS.FOUND.POS>
*        END

    C$SPARE(458)=''
    CUSTOMER.ID = TL.CUSTOMER.ID
    GOSUB READ.CUSTOMER
    GOSUB PROCESS.TL.REL.CUS.ID
    FIL.REL.CODES       = R.CUSTOMER<EB.CUS.RELATION.CODE>
    FIL.REL.CUSTOMER    = R.CUSTOMER<EB.CUS.REL.CUSTOMER>
    FIL.REL.CODES.COUNT = DCOUNT(FIL.REL.CODES,@VM)
    FIL.REL.CODES.INIT  = 1
    LOOP
    WHILE FIL.REL.CODES.INIT LE FIL.REL.CODES.COUNT
        LOCATE FIL.REL.CODES<1,FIL.REL.CODES.INIT> IN SL.PARAM.SEL.CODES<1,1,1> SETTING Y.TL.CUST.POS THEN
            IF FIL.REL.CUSTOMER<1,FIL.REL.CODES.INIT> EQ SL.CUSTOMER.ID THEN
                CUS.ROLE.INFO.VALUE = R.CUSTOMER<EB.CUS.ROLE.MORE.INFO,FIL.REL.CODES.INIT>
                CUS.ROLE.VALUE      = R.CUSTOMER<EB.CUS.ROLE,FIL.REL.CODES.INIT>
            END
        END
        LOCATE FIL.REL.CODES<1,FIL.REL.CODES.INIT> IN Y.LINK.REL.CODES<1,1,1> SETTING Y.TLL.CUST.POS THEN
            IF FIL.REL.CUSTOMER<1,FIL.REL.CODES.INIT> EQ SL.CUSTOMER.ID THEN
                C$SPARE(458) =Y.LINK.REL.DISP<1,1,Y.TLL.CUST.POS>
            END
        END
        FIL.REL.CODES.INIT += 1
    REPEAT

    CUS.ROLE.INFO.COUNT = DCOUNT(CUS.ROLE.INFO.VALUE,@SM)
    CUS.ROLE.COUNT      = DCOUNT(CUS.ROLE.VALUE,@SM)

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
**********************
PROCESS.TL.REL.CUS.ID:
**********************
* In this para of the program, the second level relation customer is processed
**
    PRODUCT.GROUP = ''
    REL.CODE      = ''

*       CALL REDO.S.REP.CUSTOMER.EXTRACT(SL.CUSTOMER.ID,PRODUCT.GROUP,REL.CODE,OUT.ARR)

    R.CUS.APP.CALL=R.CUSTOMER
    CALL DR.REG.GET.CUST.TYPE(R.CUS.APP.CALL,'',Y.CUST.TYPE,'')
    C$SPARE(453)= Y.CUST.TYPE

    TL.CUS.NATION = R.CUSTOMER<EB.CUS.NATIONALITY>
    TL.CUS.LEGAL  = R.CUSTOMER<EB.CUS.LEGAL.ID,1>
    TL.CUS.CIDENT = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.CIDENT.POS>
    TL.CUS.FOREIGN= R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.FOREIGN.POS>
    TL.CUS.RNC    = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.RNC.POS>
    C$SPARE(452) =''
    IF TL.CUS.CIDENT THEN
        C$SPARE(452) =FMT(TL.CUS.CIDENT,"R(###-#######-#)")
    END ELSE
        IF TL.CUS.RNC THEN
            C$SPARE(452) = TL.CUS.RNC
        END
        ELSE
            IF TL.CUS.LEGAL THEN
                C$SPARE(452) = TL.CUS.NATION:TL.CUS.LEGAL
            END
            ELSE
                IF TL.CUS.FOREIGN THEN
                    C$SPARE(452) = TL.CUS.NATION:TL.CUS.FOREIGN
                END
            END
        END
    END


    CUS.TIPO.CL    = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
    CUS.GIVEN.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>
    CUS.NAME.1     = R.CUSTOMER<EB.CUS.NAME.1,R.COMPANY(EB.COM.LANGUAGE.CODE)>
    CUS.NAME.2     = R.CUSTOMER<EB.CUS.NAME.2,R.COMPANY(EB.COM.LANGUAGE.CODE)>

    IF NOT(CUS.NAME.1) THEN
        CUS.NAME.1 = R.CUSTOMER<EB.CUS.NAME.1,1>
    END

    IF NOT(CUS.NAME.2) THEN
        CUS.NAME.2 = R.CUSTOMER<EB.CUS.NAME.2,1>
    END

    C$SPARE(454) = ''
    IF CUS.TIPO.CL EQ 'PERSONA FISICA' THEN
        C$SPARE(454) = CUS.GIVEN.NAME
    END

    IF CUS.TIPO.CL EQ 'PERSONA JURIDICA' THEN
        C$SPARE(454) = CUS.NAME.1:' ':CUS.NAME.2
    END

    CUS.FAM.NAME = R.CUSTOMER<EB.CUS.FAMILY.NAME>
    C$SPARE(455) = CUS.FAM.NAME

RETURN
*-----------------------------------------------------------------------------------------------------------------
****************
LOOP.THRU.ROLES:
****************
* In this para of the program, the values are looped ot display values in multiple lines, if any
**
    FINAL.ROLE.INFO = CUS.ROLE.INFO.VALUE<1,1,LOOP.INIT>
    C$SPARE(456)    = FINAL.ROLE.INFO

    FINAL.ROLE      = CUS.ROLE.VALUE<1,1,LOOP.INIT>
    C$SPARE(457)    = FMT(FINAL.ROLE,'R%2')

    GOSUB MAP.RCL.RECORD

RETURN
*-----------------------------------------------------------------------------------------------------------------
***************
MAP.RCL.RECORD:
***************
* In this para of the program, the CONDUIT.LINEAR values are fecthed and mapped
**
    MAP.FMT   = 'MAP'
    ID.RCON.L = BATCH.DETAILS<3,1,2>
    APP       = FN.CUSTOMER
    R.APP     = R.CUSTOMER
    ID.APP    = CUSTOMER.ID

    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,ID.RCON.L,APP,ID.APP,R.APP,R.RETURN.MSG,ERR.MSG)
    OUT.ARRAY = R.RETURN.MSG

    GOSUB WRITE.TO.FILE

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
        REC.CON  = 'MV32-':ERR.MSG
        DESC     = 'MV32-':ERR.MSG
        CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    END

RETURN
*-----------------------------------------------------------------------------------------------------------------
******************
RAISE.FATAL.ERROR:
******************
* In this para of the program, the FATAL.ERROR is called
**
    MESSAGE.INFO = '' ;* Handling Fatal error to halt the process
    MESSAGE.INFO<1> = 'REDO.B.LIST.OF.SHAREHOLDER'
    MESSAGE.INFO<2> = CUSTOMER.ID
    MESSAGE.INFO<3> = 'BUILD.LIST'
    MESSAGE.INFO<4> = 'Record not received'
    MESSAGE.INFO<5> = 'YES'
    TEXT = ''
    CALL FATAL.ERROR(MESSAGE.INFO)

RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
