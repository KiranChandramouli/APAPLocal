* @ValidationCode : MjotMTM5NTIzMjY4OkNwMTI1MjoxNzAyMjE2MTAxNjk2OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Dec 2023 19:18:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED , F.READ TO CACHE.READ
*21-04-2023          jayasurya H                     MANUAL R22 CODE CONVERSION            NO CHANGES
*20-11-2023          Santosh			            Intrface Change comment added           Vision Plus-Interface Changes done by Santiago
*08-12-2023	     VIGNESHWARI                      ADDED COMMENT FOR INTERFACE CHANGES        SQA-11985-By Santiago
*----------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.VALIDATE.USER.RELATION
    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.FUNDS.TRANSFER ;*Interface Changes done by Santiago
    $INSERT I_F.TELLER ;*Interface Changes done by Santiago
    $INSERT I_System ;* AUTO R22 CODE CONVERSION END
    
    GOSUB INIT ;*Interface Changes done by Santiago
    GOSUB PROCESS ;*Interface Changes done by Santiago
    
RETURN

INIT:
    CUS.EMPLOYEE = ""
    CTE.CUSTOMER = ""
RETURN

PROCESS:
*-- VALIDAMOS EN QUE VERSION SE ESTA REALIZANDO LA TRANSACCION
    IF APPLICATION EQ "TELLER" THEN
        CTE.CUSTOMER = R.NEW(TT.TE.CUSTOMER.2)     ;*SJ R.NEW(19)
    END

    IF APPLICATION EQ "FUNDS.TRANSFER" THEN
        CTE.CUSTOMER = R.NEW(FT.CREDIT.CUSTOMER)   ;*SJ  R.NEW(96)
    END

    IF APPLICATION EQ "T24.FUND.SERVICES" THEN
        CTE.CUSTOMER = R.NEW(3)
    END
*Interface Changes done by Santiago- Start
    IF CTE.CUSTOMER EQ '' THEN
*        ETEXT = 'Codigo de Cliente esta vacio'
*        CALL STORE.END.ERROR
        RETURN
    END
    
*Interface Chages done by Santiago- End
*-- PARA ABRIR EL ACHIVO USER
    FN.USER = "F.USER"
    FV.USER = ""
    RS.USER = ""
    ERR.USER = ""

    CALL OPF(FN.USER, FV.USER)
    CALL CACHE.READ(FN.USER, OPERATOR, RS.USER, ERR.USER) ;* AUTO R22 CODE CONVERSION F.READ TO CACHE.READ
    DEPARTMENT.CODE = RS.USER<EB.USE.DEPARTMENT.CODE>

*-- PARA ABRIR EL ACHIVO DEPARTMENT.CODE
    FN.DEPT = "F.DEPT.ACCT.OFFICER"
    FV.DEPT = ""
    RS.DEPT = ""
    ERR.DEPT = ""

    CALL OPF(FN.DEPT, FV.DEPT)
    CALL CACHE.READ(FN.DEPT, DEPARTMENT.CODE, RS.DEPT, ERR.DEPT) ;* AUTO R22 CODE CONVERSION F.READ TO CACHE.READ

    CALL GET.LOC.REF("DEPT.ACCT.OFFICER", "DAO.IDENT", DAO.IDENT.POS)
    DAO.IDENT = EREPLACE(RS.DEPT<EB.DAO.LOCAL.REF, DAO.IDENT.POS, 1>, "-", "")

*-- PARA ABRIR EL ACHIVO CUSTOMER
    FN.CUS = "FBNK.CUSTOMER"
    FV.CUS = ""
    RS.CUS = ""
    ERR.CUS = ""
    SEL.LIST = ""
    NO.OF.REC = ""
    SEL.ERR = ""
    IF DAO.IDENT EQ '' THEN	;*Fix SQA-11985-By Santiago-new lines added-start
        RETURN
    END	;*Fix SQA-11985-By Santiago-end
    
    SEL.CMD = "SELECT " : FN.CUS : " WITH L.CU.CIDENT EQ " : DAO.IDENT

*-- PARA ABRIR EL ACHIVO RELATION.CUSTOMER
    FN.REL = "FBNK.RELATION.CUSTOMER"
    FV.REL = ""
    RS.REL = ""
    ERR.REL = ""
    CALL OPF(FN.REL, FV.REL)

*-- EJECUTAMOS LA CONSULTA A LA TABLA CUSTOMER
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)

    LOOP

        REMOVE Y.CUS.ID FROM SEL.LIST SETTING CUS.POS

    WHILE Y.CUS.ID DO

        SEL.LIST = ""
        NO.OF.REC = ""
        SEL.ERR = ""
        SEL.CMD = "SELECT " : FN.REL : " WITH OF.CUSTOMER EQ " : CTE.CUSTOMER : " AND @ID EQ " : Y.CUS.ID

*EJECUTAMOS LA CONSULTA A LA TABLA RELATION.CUSTOMER
        CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, SEL.ERR)

        LOOP

            REMOVE Y.REL.CUS.ID FROM SEL.LIST SETTING REL.CUS.POS

*-- SI LA CONSULTA A LA TABLA RELATION.CUSTOMER FILTRANDO POR EL NUMERO DE CLIENTE DEL USUARIO DE APAP
*-- Y POR NUMERO DE CLIENTE DEL RELACIONADO TRAE REGISTROS, SIGNIFICA QUE SI SON RELACIOADOS
        WHILE Y.REL.CUS.ID DO

*-- LANZAMOS EL OVERRIDE PARA QUE LA TRANSACCION PIDA AUTORIZACION
            TEXT = 'L.APAP.VALIDATE.USER.RELATION'
            CURR.NO = 1
            CALL STORE.OVERRIDE(CURR.NO)

        REPEAT

    REPEAT
RETURN ;*Interface Changes done by Santiago

END
