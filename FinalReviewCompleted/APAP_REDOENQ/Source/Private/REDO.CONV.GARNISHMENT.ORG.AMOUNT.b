$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.GARNISHMENT.ORG.AMOUNT
*-----------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :RIYAS AHAMAD BASHA
*Program   Name    :REDO.CONV.GARNISHMENT.ORG.AMOUNT
*-----------------------------------------------------------------------------------

*DESCRIPTION       :This Program is used for convert to Amount format
*LINKED WITH       :REDO.APAP.ENQ.MM.PLCMNT.FIXD.LST
* -----------------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM and Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
* 06-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.APAP.H.GARNISH.DETAILS
    $INSERT I_System

    FN.APAP.H.GARNISH.DETAILS.HIS = 'F.APAP.H.GARNISH.DETAILS$HIS'
    F.APAP.H.GARNISH.DETAILS.HIS  = ''
    CALL OPF(FN.APAP.H.GARNISH.DETAILS.HIS,F.APAP.H.GARNISH.DETAILS.HIS)
    FN.APAP.H.GARNISH.DETAILS = 'F.APAP.H.GARNISH.DETAILS'
    F.APAP.H.GARNISH.DETAILS  = ''
    CALL OPF(FN.APAP.H.GARNISH.DETAILS,F.APAP.H.GARNISH.DETAILS)

    IF VC NE '1' THEN
        Y.SINGLE.VALUE=System.getVariable("CURRENT.AMT.BAL")
        IF E EQ "EB-UNKNOWN.VARIABLE" THEN     ;*R22 Auto Conversion  - Added IF E EQ "EB-UNKNOWN.VARIABLE" THEN
            Y.SINGLE.VALUE = ""
        END
        O.DATA = Y.SINGLE.VALUE<1,VC>
    END
    ELSE
        Y.VAR = O.DATA:';1'
        Y.ENQ.SELECTION = ENQ.SELECTION<1>
        CALL F.READ(FN.APAP.H.GARNISH.DETAILS.HIS,Y.VAR,R.APAP.H.GARNISH.DETAILS.HIS,F.APAP.H.GARNISH.DETAILS.HIS,GARNISH.ERR)
        IF R.APAP.H.GARNISH.DETAILS.HIS THEN
            IF Y.ENQ.SELECTION EQ 'REDO.E.GARNISH.DETAILS' THEN
                O.DATA=R.APAP.H.GARNISH.DETAILS.HIS<APAP.GAR.GARNISH.AMT>
            END
        END ELSE
            Y.VAR = O.DATA
            CALL F.READ(FN.APAP.H.GARNISH.DETAILS,Y.VAR,R.APAP.H.GARNISH.DETAILS,F.APAP.H.GARNISH.DETAILS,GARNISH.ERR)
            O.DATA=R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISHMENT.AMT>
            IF Y.ENQ.SELECTION EQ 'REDO.E.GARNISH.DETAILS' THEN
                O.DATA=R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISH.AMT>
            END
        END
        Y.OD = O.DATA
        VM.COUNT = DCOUNT(Y.OD,@VM)
        CALL System.setVariable("CURRENT.AMT.BAL",Y.OD)
        O.DATA = Y.OD<1,VC>
    END
RETURN
END
