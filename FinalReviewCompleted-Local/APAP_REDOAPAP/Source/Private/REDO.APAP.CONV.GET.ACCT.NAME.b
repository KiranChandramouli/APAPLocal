* @ValidationCode : MjotNjQ2ODk0MjM0OkNwMTI1MjoxNjgxMjgyNzI3NjQ3OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:28:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.CONV.GET.ACCT.NAME
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
* 12-11-2010      Sakthi Sellappillai         ODR-2010-08-0173            Initial Creation
* 03-05-2013      Arundev                     PACS00260027                4360 - Cadena 9357 - 72.REPORTE DE FONDOS EN TRANSITO. (Issues Criticos)
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   = to EQ , VM to @VM ,++ to +=,FM to @FM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
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
    R.ACCOUNT.HIS.REC = ''
    FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT$HIS = ''
    CALL OPF(FN.ACCOUNT$HIS,F.ACCOUNT$HIS)
    Y.ACCOUNT.HIS.ERR = ''
RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
    APPL.ARRAY = "CUSTOMER"
    FIELD.ARRAY = "L.CU.TIPO.CL"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
    LOC.L.CU.TIPO.CL.POS = FIELD.POS
    Y.ACCOUNT.ID = O.DATA
    Y.HIS.ACCT.ID = ''
    Y.HIS.SYM.VAL = FIELD(Y.ACCOUNT.ID,';',2,1)
    IF Y.HIS.SYM.VAL THEN
        Y.HIS.ACCT.ID = FIELD(Y.ACCOUNT.ID,';',1,1)
        CALL EB.READ.HISTORY.REC(F.ACCOUNT$HIS,Y.HIS.ACCT.ID,R.ACCOUNT.HIS.REC,Y.ACCOUNT.HIS.ERR)
        CUSTOMER.ID = R.ACCOUNT.HIS.REC<AC.CUSTOMER>
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,Y.ACCOUNT.ERR)
        CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    END
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END

    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN ;*R22 AUTO CODE CONVERSION
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
    END

    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
        Y.CUS.NAMES = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
    END

    IF Y.HIS.ACCT.ID EQ '' THEN
        Y.RELATION.COUNT = DCOUNT(R.ACCOUNT<AC.RELATION.CODE>,@VM)
    END ELSE
        Y.RELATION.COUNT = DCOUNT(R.ACCOUNT.HIS.REC<AC.RELATION.CODE>,@VM)
    END

    Y.COUNT = 1
    IF Y.RELATION.COUNT THEN
        GOSUB CHECK.NAMES
    END

    IF NOT(Y.ACC.NAMES) THEN
        Y.ACC.NAMES  =  Y.CUS.NAMES
    END ELSE

        Y.ACC.NAMES = Y.CUS.NAMES:@FM:Y.ACC.NAMES
    END
*   Y.VC = DCOUNT(Y.ACC.NAMES,FM)
*   VC = Y.VC
*   IF VC EQ 1 THEN
**VM.COUNT = DCOUNT(Y.ACC.NAMES,FM) ;*PACS00260027 - multi value dates are not displayed becuase overriding common variable VM.COUNT
*       O.DATA = Y.ACC.NAMES<VC>
*   END ELSE
*       O.DATA =Y.ACC.NAMES<VC>
*    END
    CHANGE @FM TO '; ' IN Y.ACC.NAMES
    O.DATA = Y.ACC.NAMES
RETURN
*-------------------------------------------------------------------------------------
CHECK.NAMES:
    LOOP
    WHILE Y.COUNT LE Y.RELATION.COUNT
        Y.CONT.FLAG = ''
        IF Y.HIS.ACCT.ID EQ '' THEN
            RELATION.ID = R.ACCOUNT<AC.RELATION.CODE,Y.COUNT>
        END ELSE
            RELATION.ID = R.ACCOUNT.HIS.REC<AC.RELATION.CODE,Y.COUNT>
        END
        IF RELATION.ID LT 500 OR RELATION.ID GT 529 THEN
            Y.COUNT += 1
            Y.CONT.FLAG = 1
        END
        IF NOT(Y.CONT.FLAG) THEN
            CALL F.READ(FN.RELATION,RELATION.ID,R.RELATION,F.RELATION,RELATION.ER)

            Y.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>
            IF Y.HIS.ACCT.ID EQ '' THEN
                CUSTOMER.ID = R.ACCOUNT<AC.JOINT.HOLDER,Y.COUNT>
            END ELSE
                CUSTOMER.ID = R.ACCOUNT.HIS.REC<AC.JOINT.HOLDER,Y.COUNT>
            END
            CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ER)

            IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
                Y.CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
            END

            IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN ;*R22 AUTO CODE CONVERSION
                Y.CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
            END

            IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.TIPO.CL.POS>) THEN
                Y.CUS.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
            END

            Y.ACC.NAMES<-1>= Y.REL.DESC:'-':Y.CUS.NAME
*Y.ACC.NAMES<-1>= Y.CUS.NAMES:'-':Y.REL.DESC:'-':Y.CUS.NAME
            Y.ACC.NAMES = CHANGE(Y.ACC.NAMES, @FM, '; ')

            Y.COUNT += 1 ;*R22 AUTO CODE CONVERSION
        END
    REPEAT
RETURN
END
