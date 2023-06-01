* @ValidationCode : MjotNzI3MDY4NzY1OkNwMTI1MjoxNjgxMjc2NTU1NTY1OklUU1M6LTE6LTE6MzczOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 373
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.AC.TUTOR
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AC.TUTOR
*--------------------------------------------------------------------------------------------------------
*Description       :
*
*Linked With       : ACCOUNT VERSION
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : ACCOUNT
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date                 Who                  Reference                 Description
*  ------               -----               -------------              -------------
* 09.12.2010           Manju G            ODR-2010-12-0495           Initial Creation
* 05-02-2010           Prabhu N            N106 HD Issue             Routine modified to support when there is no relation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB PROCESS
RETURN
INIT:
********
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    APPL = ''; FIELD.NAMES = '';FIELD.POS = '' ;Y.SET.ERROR = 1 ; Y.REL.CT = 1
    APPL = 'CUSTOMER'
    FIELD.NAMES = 'L.CU.AGE'
    CALL MULTI.GET.LOC.REF(APPL,FIELD.NAMES,FIELD.POS)
    L.CU.AGE.POS = FIELD.POS<1,1>
RETURN
************
PROCESS:
*************
    IF APPLICATION EQ 'ACCOUNT' THEN
        Y.AC.CUSTOMER = R.NEW(AC.CUSTOMER)
        CALL F.READ(FN.CUSTOMER,Y.AC.CUSTOMER,R.CUSTOMER,F.CUSTOMER,ERR.CUST)
    END

    IF APPLICATION EQ 'AZ.ACCOUNT' THEN
        Y.AZ.CUSTOMER = R.NEW(AZ.CUSTOMER)
        CALL F.READ(FN.CUSTOMER,Y.AZ.CUSTOMER,R.CUSTOMER,F.CUSTOMER,ERR.CUST)
    END

    Y.L.CU.AGE = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.AGE.POS>
    IF Y.L.CU.AGE NE '' THEN
        IF Y.L.CU.AGE LT '14' THEN
            Y.RELATION.CODE = R.NEW(AC.RELATION.CODE)
            Y.RELATION.COUNT = DCOUNT(Y.RELATION.CODE,@VM)
            GOSUB CHECK.REL.CODE
            IF Y.SET.ERROR EQ 1 THEN
                GOSUB RISE.ERROR
            END
        END
    END
RETURN
***************
CHECK.REL.CODE:
***************
    IF Y.RELATION.COUNT THEN
        Y.REL.CT = 0
        LOOP
        WHILE Y.REL.CT LE Y.RELATION.COUNT
            Y.RELATION.CO = Y.RELATION.CODE<1,Y.REL.CT>
            IF Y.RELATION.CO GE '510' AND Y.RELATION.CO LE '529' THEN
                Y.REL.CT=Y.RELATION.COUNT
                Y.SET.ERROR=''
            END ELSE
                Y.SET.ERROR=1
            END
            Y.REL.CT += 1
        REPEAT
    END
RETURN
************
RISE.ERROR:
**************
    AF = AC.RELATION.CODE
    AV = Y.REL.CT
    ETEXT = 'EB-REDO.AC.TUTOR'
    CALL STORE.END.ERROR
RETURN
END
