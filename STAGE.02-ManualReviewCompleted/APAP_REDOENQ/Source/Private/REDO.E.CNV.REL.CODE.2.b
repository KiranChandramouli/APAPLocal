$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.REL.CODE.2

*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.E.CNV.REL.CODE.2
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a conversion routine in the
* Enquiry REDO.REPRESENTANTE.LEGAL to populate the label rel.code
*-----------------------------------------------------------------------------
* Linked with : Enquiry REDO.REPRESENTANTE.LEGAL as conversion routine
* In Parameter : None
* Out Parameter : None
*-----------------------------------------------------------------------------
* Modification History:
*-----------------------------------------------------------------------------
*  DATE             WHO           REFERENCE          DESCRIPTION
* 07-08-2010      SUJITHA.S      ODR-2009-10-0534   INITIAL CREATION
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM , CONVERT to CHANGE , -- to -= and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER

    GOSUB INIT
    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

*-------------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------------

    CALL F.READ(FN.CUSTOMER,ID,R.CUSTOMER,F.CUSTOMER,ERR.CUSTOMER)
    Y.REL.CODE = R.RECORD<EB.CUS.RELATION.CODE>
    CHANGE @VM TO @FM IN Y.REL.CODE      ;*R22 Auto Conversion  - CONVERT to CHANGE
    FET.REL.CODE = Y.REL.CODE
    Y.REL.CNT = DCOUNT(Y.REL.CODE,@FM)
    START.LOOP = 1
    LOOP
    WHILE START.LOOP LE Y.REL.CNT
        FIND.POS = ''
        REL.CODE = Y.REL.CODE<START.LOOP>
*---------------------------------------------------
* Here, the unwanted values are restricted from the record
*---------------------------------------------------
        LOCATE REL.CODE IN FET.REL.CODE SETTING FIND.POS THEN
            IF REL.CODE EQ 104 ELSE
                DEL R.RECORD<EB.CUS.RELATION.CODE,FIND.POS>
                DEL R.RECORD<EB.CUS.REL.CUSTOMER,FIND.POS>
                DEL R.RECORD<EB.CUS.REVERS.REL.CODE,FIND.POS>
                DEL R.RECORD<EB.CUS.REL.DELIV.OPT,FIND.POS>
                DEL R.RECORD<EB.CUS.ROLE,FIND.POS>
                DEL R.RECORD<EB.CUS.ROLE.MORE.INFO,FIND.POS>
                DEL R.RECORD<EB.CUS.ROLE.NOTES,FIND.POS>
                DEL FET.REL.CODE<FIND.POS>
                VM.COUNT -= 1
            END
        END
        START.LOOP += 1
    REPEAT

RETURN
END
