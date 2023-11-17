* @ValidationCode : MjoxNzM1MzY2MTU3OkNwMTI1MjoxNjgzMDI0MzM0ODc0OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 May 2023 16:15:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.INP.CHK.CUST.RESTR
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : BHARATH C
* Program Name  : REDO.V.INP.CHK.CUST.RESTR
* ODR NUMBER    : ODR-2009-10-0522
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         INCLUDE TO INSERT, VM TO @VM
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------------------------


* Description: Whenever a customer record is being created along with the basic
* details like customer name, address, Date of Birth etc these details are also
* captured.At the moment of committing a record the system should first check for
* the values in the Local ref Field L.CU.TIPO.CL. If the value for L.CU.TIPO.CL
* is.CLIENTE MENOR. then the client is a minor and his name needs not be checked in
* the restricted list and we may allow committing the record and creating customer id
* However if the If the values for L.Cu.TIPO.CL  is "PERSONA FISICA"
* or "PERSONA JURIDICA" and CUSTOMER.TYPE is .active. then the system should
* verify whether the customer is present in the restrictive list

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------------------

    $INSERT I_COMMON  ;*AUTO R22 CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.RESTRICTIVE.LIST

    IF APPLICATION EQ 'CUSTOMER' THEN
        GOSUB INIT
        GOSUB OPENFILE
        GOSUB PROCESS
        GOSUB PGM.END
    END
RETURN

****************
INIT:
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CUSTOMER.ERR=''
    CUSTOMER.ID=''
    LOCAL.POS=''
    L.CU.TIPO.CL.POS=''
    L.CU.TIPO.CL.VAL=''
    L.CU.LISTA.REST.POS=''
    L.CU.LISTA.REST.VAL=''
    Y.OLD.DOC.NAME=''
    Y.NEW.DOC.NAME=''
    Y.OLD.LEGAL.ID=''
    Y.NEW.LEGAL.ID=''
    SEL.CMD=''
    SEL.RESTRICTIVE.LIST=''
    NO.OF.REC=''
    ERR=''
    Y.OLD.L.CU.CIDENT=''
    Y.NEW.L.CU.CIDENT=''
    Y.OLD.L.CU.RNC=''
    Y.NEW.L.CU.RNC=''
    L.CU.CIDENT.POS=''
    L.CU.RNC.POS=''
    L.CU.PASS.NAT.POS = ''
    FN.REDO.RESTRICTIVE.LIST='F.REDO.RESTRICTIVE.LIST'
    F.REDO.RESTRICTIVE.LIST=''
    R.REDO.RESTRICTIVE.LIST=''; REDO.RESTRICTIVE.LIST.ERR=''
RETURN
****************
OPENFILE:
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.REDO.RESTRICTIVE.LIST,F.REDO.RESTRICTIVE.LIST)
    FN.REDO.RESTRICT.CUST.CONCAT = 'F.REDO.RESTRICT.CUST.CONCAT'; F.REDO.RESTRICT.CUST.CONCAT = ''
    CALL OPF(FN.REDO.RESTRICT.CUST.CONCAT,F.REDO.RESTRICT.CUST.CONCAT)
    LOCAL.APP = 'CUSTOMER'
    LOCAL.FIELD = 'L.CU.TIPO.CL':@VM:'L.CU.LISTA.REST':@VM:'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.PASS.NAT'
    LOCAL.POS = ''
    CALL MULTI.GET.LOC.REF(LOCAL.APP,LOCAL.FIELD,LOCAL.POS)
    L.CU.TIPO.CL.POS=LOCAL.POS<1,1>
    L.CU.LISTA.REST.POS=LOCAL.POS<1,2>
    L.CU.CIDENT.POS=LOCAL.POS<1,3>
    L.CU.RNC.POS=LOCAL.POS<1,4>
    L.CU.PASS.NAT.POS = LOCAL.POS<1,5>
RETURN
*************
PROCESS:
***************
    CUSTOMER.ID=ID.NEW
    R.CUSTOMER=''
    L.CU.TIPO.CL.VAL = R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.TIPO.CL.POS>
    L.CU.LISTA.REST.VAL = R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.LISTA.REST.POS>

    Y.OLD.DOC.NAME=R.OLD(EB.CUS.LEGAL.DOC.NAME)
    Y.OLD.LEGAL.ID=R.OLD(EB.CUS.LEGAL.ID)
    Y.OLD.L.CU.CIDENT=R.OLD(EB.CUS.LOCAL.REF)<1,L.CU.CIDENT.POS>
    Y.OLD.L.CU.RNC=R.OLD(EB.CUS.LOCAL.REF)<1,L.CU.RNC.POS>

    Y.OLD.L.CU.TIPO.CL=R.OLD(EB.CUS.LOCAL.REF)<1,L.CU.TIPO.CL.POS>    ;*HD1030804
    Y.NEW.L.CU.TIPO.CL=R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.TIPO.CL.POS>    ;*HD1030804

    Y.NEW.DOC.NAME=R.NEW(EB.CUS.LEGAL.DOC.NAME)
    Y.NEW.LEGAL.ID=R.NEW(EB.CUS.LEGAL.ID)
    Y.NEW.L.CU.CIDENT=R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.CIDENT.POS>
    Y.NEW.L.CU.RNC=R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.RNC.POS>
    Y.NEW.L.CU.PASSNAT=R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.PASS.NAT.POS>
    Y.NEW.NATION = R.NEW(EB.CUS.NATIONALITY)
**********************CUSTOMER TYPE CLOSED TO ACTIVE
    CUSTOMER.OLD.STATUS=R.OLD(EB.CUS.CUSTOMER.STATUS)
    CUSTOMER.NEW.STATUS=R.NEW(EB.CUS.CUSTOMER.STATUS)

    IF L.CU.LISTA.REST.VAL EQ 'SI' THEN
        AF = EB.CUS.LOCAL.REF
        AV = L.CU.LISTA.REST.POS
        ETEXT='AA-REDO.CUST.RESTR'
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END

    IF CUSTOMER.OLD.STATUS EQ '4' AND CUSTOMER.NEW.STATUS EQ '1' AND L.CU.LISTA.REST.VAL EQ 'SI' THEN
        AF=EB.CUS.CUSTOMER.STATUS
        ETEXT='AA-REDO.CUST.RESTR'
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END
***************** CLIENTE MENOR
    IF L.CU.TIPO.CL.VAL EQ 'CLIENTE MENOR' THEN
        RETURN
    END

*********************************************************CHECKING CUSTOMER OPENING RECORD
    VAR.CURR.NO = R.OLD(EB.CUS.CURR.NO)
*IF Y.OLD.LEGAL.ID EQ '' OR Y.OLD.L.CU.CIDENT EQ '' OR Y.OLD.L.CU.RNC EQ '' THEN
    IF NOT(VAR.CURR.NO) THEN
        GOSUB PROCESSVERIFY
        GOSUB PGM.END
    END
*******CHANGE IN OLD VALUE********CHECKING MODIFICATION CUSTOMER********

    GOSUB PROCESSVERIFY
    GOSUB PGM.END
RETURN

*************
PROCESSVERIFY:
*************
    BEGIN CASE
        CASE Y.NEW.L.CU.CIDENT NE ''
            VAR.NUMERO.DOC = Y.NEW.L.CU.CIDENT
            AF = EB.CUS.LOCAL.REF
            AV = L.CU.CIDENT.POS
            GOSUB CHECK.REST.LIST
        CASE Y.NEW.L.CU.RNC NE ''
            VAR.NUMERO.DOC = Y.NEW.L.CU.RNC
            AF = EB.CUS.LOCAL.REF
            AV =L.CU.RNC.POS
            GOSUB CHECK.REST.LIST
        CASE Y.NEW.L.CU.PASSNAT NE ''
            YCUST = ''
            YCUST = FIELD(Y.NEW.L.CU.PASSNAT,'-',1)
            VAR.NUMERO.DOC = YCUST:'-':Y.NEW.NATION
            AF = EB.CUS.LOCAL.REF
            AV = L.CU.PASS.NAT.POS
            GOSUB CHECK.REST.LIST
        CASE Y.NEW.LEGAL.ID NE ''
            VAR.NUMERO.DOC = Y.NEW.LEGAL.ID
            AF = EB.CUS.LEGAL.ID
            GOSUB CHECK.REST.LIST
    END CASE
RETURN

****************
CHECK.REST.LIST:
*****************
    ERR.REDO.RESTRICT.CUST.CONCAT = ''; R.REDO.RESTRICT.CUST.CONCAT = ''
    CALL F.READ(FN.REDO.RESTRICT.CUST.CONCAT,VAR.NUMERO.DOC,R.REDO.RESTRICT.CUST.CONCAT,F.REDO.RESTRICT.CUST.CONCAT,ERR.REDO.RESTRICT.CUST.CONCAT)
*    SEL.CMD="SELECT ":FN.REDO.RESTRICTIVE.LIST:' WITH NUMERO.DOCUMENTO EQ ':VAR.NUMERO.DOC
*    CALL EB.READLIST(SEL.CMD,SEL.RESTRICTIVE.LIST,'',NO.OF.REC,REDO.RESTRICTIVE.LIST.ERR)
    IF R.REDO.RESTRICT.CUST.CONCAT THEN
        ETEXT='AA-REDO.CUST.RESTR'
        CALL STORE.END.ERROR
        GOSUB PGM.END
    END ELSE
        R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.LISTA.REST.POS> = 'NO'
    END
RETURN
*******************************************
PGM.END:
*******************************************
END
