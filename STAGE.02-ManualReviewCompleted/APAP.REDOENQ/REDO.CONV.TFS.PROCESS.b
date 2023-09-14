$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.TFS.PROCESS
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the descriptions
*------------------------------------------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 28-07-2012   SUDHARSANAN   PACS00208938     Initial creation
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER

    GOSUB PROCESS
RETURN
**********
PROCESS:
*********

    Y.LOOKUP.ID   = "L.AZ.METHOD.PAY"
    Y.LOOOKUP.VAL = O.DATA
    Y.DESC.VAL    = ''

    BEGIN CASE
        CASE Y.LOOOKUP.VAL EQ 'CASHDEPOSIT'
            Y.LOOOKUP.VAL = 'CASHDEPOSIT'
        CASE Y.LOOOKUP.VAL EQ 'CHQDEP'
            Y.LOOOKUP.VAL = 'CHEQUE.DEPOSIT'
        CASE Y.LOOOKUP.VAL EQ 'FROM'
            Y.LOOOKUP.VAL = 'FROM.CUST.ACC'
    END CASE

    CALL REDO.EB.LOOKUP.LIST(Y.LOOKUP.ID,Y.LOOOKUP.VAL,Y.DESC.VAL,RES1,RES2)

    IF Y.DESC.VAL THEN
        O.DATA = Y.DESC.VAL
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------
END
