* @ValidationCode : MjotMTk3NzI5MTQwODpDcDEyNTI6MTY4MTI5OTcxMDk3MTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 17:11:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.UPD.SEG
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is an input routine attached to the version CUSTOMER,REDO.SEGMENTACION
* to over write APAP.CUSTOMER.SEGMENT field value with APAP.OVR.SEGMENT value
* when APAP.OVR.SEGMENT is not null and different from APAP.CUSTOMER.SEGMENT field value
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who                 Reference                    Description
* 03-MAY-2010   N.Satheesh Kumar       ODR-2009-12-0281               Initial Creation
*12-04-2023       Conversion Tool      R22 Auto Code conversion          VM TO @VM
*12-04-2023        Samaran T           R22 Manual Code conversion        No Changes
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_GTS.COMMON

    IF V$FUNCTION NE 'I' THEN
        GOSUB PGM.END
    END

    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB PGM.END
RETURN
*------------
OPEN.FILES:
*------------
    LOC.REF.POS = ''
    CUS.SEG.POS = ''
    OVR.SEG.POS = ''
    CUS.SEG.VAL = ''
    OVR.SEG.VAL = ''
    LOC.REF.FIELDS = 'L.CU.SEGMENTO':@VM:'L.CU.OVR.SEGM':@VM:'L.CU.TIPO.CL':@VM:'L.CU.CIDENT':@VM:'L.CU.ACTANAC':@VM:'L.CU.NOUNICO'
    CALL MULTI.GET.LOC.REF('CUSTOMER',LOC.REF.FIELDS,LOC.REF.POS)

    CUS.SEG.POS = LOC.REF.POS<1,1>
    OVR.SEG.POS = LOC.REF.POS<1,2>
    L.CU.TIPO.CL.POS = LOC.REF.POS<1,3>
    L.CU.CIDENT.POS = LOC.REF.POS<1,4>
    L.CU.ACTANAC.POS = LOC.REF.POS<1,5>
    L.CU.NOUNICAO.POS = LOC.REF.POS<1,6>

RETURN
*---------
PROCESS:
*---------
    CUS.SEG.VAL = R.NEW(EB.CUS.LOCAL.REF)<1,CUS.SEG.POS>
    OVR.SEG.VAL = R.NEW(EB.CUS.LOCAL.REF)<1,OVR.SEG.POS>

    IF OVR.SEG.VAL NE '' AND OVR.SEG.VAL NE CUS.SEG.POS THEN
        R.NEW(EB.CUS.LOCAL.REF)<1,CUS.SEG.POS> = OVR.SEG.VAL
    END

    VAR.TIPO.CL = R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.TIPO.CL.POS>
    Y.CIDENT = R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.CIDENT.POS>
    Y.LEGAL = R.NEW(EB.CUS.LEGAL.ID)
    Y.ACTANAC = R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.ACTANAC.POS>
    Y.NOUN = R.NEW(EB.CUS.LOCAL.REF)<1,L.CU.NOUNICAO.POS>
    Y.GIVEN.NAMES = R.NEW(EB.CUS.GIVEN.NAMES)
    Y.FAMILY.NAME = R.NEW(EB.CUS.FAMILY.NAME)
    Y.DOB = R.NEW(EB.CUS.DATE.OF.BIRTH)

    IF (OFS$OPERATION EQ 'PROCESS') OR (OFS$OPERATION EQ 'VALIDATE') THEN

        BEGIN CASE
            CASE VAR.TIPO.CL EQ "PERSONA FISICA"
                IF Y.CIDENT NE '' OR Y.LEGAL NE '' THEN
                    GOSUB CHECK.CONDITION
                END

            CASE VAR.TIPO.CL EQ "CLIENTE MENOR"
                IF Y.CIDENT NE '' OR Y.LEGAL NE '' OR Y.ACTANAC NE '' OR Y.NOUN NE '' THEN
                    GOSUB CHECK.CONDITION
                END

            CASE 1
                GOSUB PGM.END

        END CASE

    END
RETURN
*---------------------
CHECK.CONDITION:
*--------------------

    IF NOT(Y.GIVEN.NAMES) THEN
        AF = EB.CUS.GIVEN.NAMES
        GOSUB CHECK.ERROR
    END

    IF NOT(Y.FAMILY.NAME) THEN
        AF = EB.CUS.FAMILY.NAME
        GOSUB CHECK.ERROR
    END

    IF NOT(Y.DOB) THEN
        AF = EB.CUS.DATE.OF.BIRTH
        GOSUB CHECK.ERROR
    END

RETURN
*----------------
CHECK.ERROR:
*----------------

    ETEXT ='AC-MAND.FLD'
    CALL STORE.END.ERROR

RETURN
*---------
PGM.END:
*---------
END
