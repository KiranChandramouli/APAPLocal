* @ValidationCode : MjotMTYzOTcwMTUxNjpDcDEyNTI6MTY4MjQ5ODEzOTM1MzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Apr 2023 14:05:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.STMT.CONV.GET.ACCT.NAME
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.GET.ACCT.NAME
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to fetch the value of ACCOUNT.NAME from ACCOUNT
*Linked With  :
*In Parameter : O.DATA
*Out Parameter: O.DATA
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  Date            Who                        Reference                    Description
* ------          ------                      -------------                -------------
* 12-11-2010      Sakthi Sellappillai         ODR-2010-08-0031           Initial Creation
** 17-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 17-04-2023 Skanda R22 Manual Conversion - added APAP.TAM, CALL routine format modified
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.RELATION
    $INSERT I_F.RELATION.CUSTOMER

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*---------------------------
INITIALISE:
*---------------------------
    REF.POS = ''
    CONCAT1 = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    R.CUSTOMER = ''
    CUSTOMER.ERR = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    R.ACCOUNT.REC = ''
    Y.ACCOUNT.ERR = ''
    Y.ACCOUNT.ID = ''
    JOINT.HOLDER.VAL = ''
    CUSTOMER.ID = ''
    IS.RELATIONS.CNT = ''
    IS.RELATIONS.LIST = ''
    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)
    R.RELATION.REC = ''
    Y.RELATION.ERR = ''
    IS.RELATION.NO = ''
    IS.RELATION.ID = ''
    IS.RELATION.DESC = ''
    IS.CUST.NAMES = ''
    Y.FINAL.ACCT.NAME = ''
    Y.ACC.NAMES = ''
RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    APPL.ARRAY = "CUSTOMER"
    FIELD.ARRAY = "L.CU.TIPO.CL"
    FIELD.POS = ''
    CALL APAP.TAM.MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS) ;*MANUAL R22 CODE CONVERSION
    LOC.L.CU.TIPO.CL.POS = FIELD.POS
    Y.ACCOUNT.ID = O.DATA

    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.ACCOUNT.ERR)

    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>

    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN ;* R22 Auto conversion
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN ;* R22 Auto conversion
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    END

    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
    END

    Y.RELATION.COUNT = DCOUNT(R.ACCOUNT<AC.RELATION.CODE>,@VM)

    Y.COUNT = 1
    IF Y.RELATION.COUNT THEN
        LOOP
        WHILE Y.COUNT LE Y.RELATION.COUNT
            RELATION.ID = R.ACCOUNT<AC.RELATION.CODE,Y.COUNT>

            IF RELATION.ID LT 500 OR RELATION.ID GT 529 THEN
                Y.COUNT += 1
                CONTINUE
            END

            CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,RELATION.ER)

            Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>

            CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.COUNT>

            CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)

            IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN ;* R22 Auto conversion
                Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
            END

            IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN ;* R22 Auto conversion
                Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
            END

            IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
                Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
            END

            Y.ACC.NAMES<-1>= Y.CUS.NAMES:'-':Y.REL.DESC:'-':Y.CUS.NAME

            Y.COUNT += 1 ;* R22 Auto conversion
        REPEAT
    END
    CHANGE @FM TO @VM IN Y.ACC.NAMES

    IF Y.ACC.NAMES THEN
        O.DATA = Y.ACC.NAMES
        RETURN
    END

    IF Y.CUS.NAMES THEN
        O.DATA = Y.CUS.NAMES
        RETURN
    END

    O.DATA = ''

RETURN
*-------------------------------------------------------------------------------------
END
