$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.ENQ.CUST.LIST.ACC(Y.FINAL.ARRAY)
*-----------------------------------------------------------------------------
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : Sudharsanan S
*  ODR Number        : CR.018 - Version Integration
*  Program   Name    : REDO.ENQ.CUST.LIST.ACC
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : Y.FINAL.ARRAY
*-------------------------------------------------------------------------------------------------------------
* DESCRIPTION       : This is a NOFILE enquiry routine to get the customer accounts based on specific category
*-------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO            REFERENCE                       DESCRIPTION
*  -----           ----           ----------                      -----------
*  21-OCT-2011   Sudharsanan  CR.018 - VERSION INTEGRATION   INITIAL CREATION
* 12-APRIL-2023      Harsha                R22 Auto Conversion  - FM to @FM , Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN , ++ to +=
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_System

    GOSUB INITIALIZE
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------
INITIALIZE:
*----------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    F.CUSTOMER.ACCOUNT = ''
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    FN.JOINT.CONTRACTS.XREF = 'F.JOINT.CONTRACTS.XREF'
    F.JOINT.CONTRACTS.XREF = ''
    CALL OPF(FN.JOINT.CONTRACTS.XREF,F.JOINT.CONTRACTS.XREF)

    Y.AZ.ID = System.getVariable("CURRENT.AZ.ID.REF")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN	;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.AZ.ID = ""
    END

    CALL F.READ(FN.ACCOUNT,Y.AZ.ID,R.CUR.AZ,F.ACCOUNT,ACC.ERR)

    Y.CURRENCY = R.CUR.AZ<AC.CURRENCY>
    Y.CUS.ID   = R.CUR.AZ<AC.CUSTOMER>

    R.ACCOUNT  = ''
    SEL.CMD    = ''
    Y.TOTAL.ACC = ''
    NO.OF.REC = ''
    SEL.ERR.AC = ''

RETURN
*-------------------------------------------------------------------------------
OPENFILES:
*---------

    LOCATE "CUSTOMER.CODE" IN D.FIELDS SETTING Y.CUST.POS THEN
        Y.CUS.ID = D.RANGE.AND.VALUE<Y.CUST.POS>
    END

RETURN
*-------------------------------------------------------------------------------
PROCESS:
*-------

    GOSUB GET.CUSTOMER.ACCOUNT
    Y.FINAL.ARRAY = Y.TOTAL.ACC

RETURN
*-------------------------------------------------------------------------------
GET.CUSTOMER.ACCOUNT:
*-------------------------------------------------------------------------------

    CALL F.READ(FN.CUSTOMER.ACCOUNT,Y.CUS.ID,R.CUS.ACC,F.CUSTOMER.ACCOUNT,CUS.ACC.ERR)
    CALL F.READ(FN.JOINT.CONTRACTS.XREF,Y.CUS.ID,R.JOINT.XREF,F.JOINT.CONTRACTS.XREF,JOINT.ERR)

    Y.OWN.ACC.CNT = DCOUNT(R.CUS.ACC,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.OWN.ACC.CNT
        Y.ACC.ID = R.CUS.ACC<Y.VAR1>
        IF Y.ACC.ID NE Y.AZ.ID THEN
            CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
            Y.CATEG = R.ACC<AC.CATEGORY>
            IF ((Y.CATEG GE 1001 AND Y.CATEG LE 1099) OR (Y.CATEG GE 6001 AND Y.CATEG LE 6010) OR (Y.CATEG GE 6021 AND Y.CATEG LE 6599)) THEN
                Y.TOTAL.ACC<-1> = Y.ACC.ID
            END
        END
        Y.VAR1 += 1
    REPEAT

    Y.JOIN.ACC.CNT = DCOUNT(R.JOINT.XREF,@FM)
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.JOIN.ACC.CNT
        Y.JOIN.ACC.ID = R.JOINT.XREF<Y.VAR2>
        CALL F.READ(FN.ACCOUNT,Y.JOIN.ACC.ID,R.JOIN.ACC,F.ACCOUNT,ACC.ERR)
        Y.CATEG = R.JOIN.ACC<AC.CATEGORY>
        IF ((Y.CATEG GE 1001 AND Y.CATEG LE 1099) OR (Y.CATEG GE 6001 AND Y.CATEG LE 6010) OR (Y.CATEG GE 6021 AND Y.CATEG LE 6599)) THEN
            LOCATE Y.CUS.ID IN R.JOIN.ACC<AC.JOINT.HOLDER,1> SETTING POS THEN
                IF R.JOIN.ACC<AC.RELATION.CODE,POS> GE 500 AND R.JOIN.ACC<AC.RELATION.CODE,POS> LE 509 THEN
                    Y.TOTAL.ACC<-1> = Y.JOIN.ACC.ID
                END
            END
        END
        Y.VAR2 += 1
    REPEAT

RETURN
*-------------------------------------------------------------------------------
END
