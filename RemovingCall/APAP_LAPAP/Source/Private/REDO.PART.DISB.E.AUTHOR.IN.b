* @ValidationCode : MjoxNjEzMTI1OTI0OkNwMTI1MjoxNjg0MjIyODMzODQyOklUU1M6LTE6LTE6Mzk3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 397
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           SM TO @SM, FM TO @FM,
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.PART.DISB.E.AUTHOR.IN(ENQ.DATA)

    $INSERT I_EQUATE ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
    $INSERT I_F.REDO.DISB.CHAIN ;*AUTO R22 CODE CONVERSION - END

*REDO.AA.PART.DISBURSE.FC

    FN.REDO.DISB.CHAIN = 'F.REDO.DISB.CHAIN'; F.REDO.DISB.CHAIN = ''
    CALL OPF(FN.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN)
    FN.REDO.AA.PART.DISBURSE.FC = 'F.REDO.AA.PART.DISBURSE.FC'; F.REDO.AA.PART.DISBURSE.FC = ''
    CALL OPF(FN.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC)

*DEBUG
    ID.CC = ID.COMPANY
    SEL.DET = ''; SEL.CMD = ''; SEL.LIST = ''
    SEL.CMD="SELECT ":FN.REDO.DISB.CHAIN:" WITH DISB.STATUS EQ 'UP' AND BRANCH.ID EQ " : ID.CC
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.SLT)
    LOOP
        REMOVE SEL.ID FROM SEL.LIST SETTING SEL.POSN
    WHILE SEL.ID:SEL.POSN
        ERR.REDO.DISB.CHAIN = ''; R.REDO.DISB.CHAIN = ''
        CALL F.READ(FN.REDO.DISB.CHAIN ,SEL.ID,R.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN,ERR.REDO.DISB.CHAIN)
        ARR.ID = R.REDO.DISB.CHAIN<DS.CH.RPD.ID>
*ARR.ID = R.REDO.DISB.CHAIN<DS.CH.RCA.ID>
        R.REDO.AA.PART.DISBURSE.FC = ''; ERR.REDO.AA.PART.DISBURSE.FC = ''
        CALL F.READ (FN.REDO.AA.PART.DISBURSE.FC,ARR.ID,R.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC,ERR.REDO.AA.PART.DISBURSE.FC)

        A.AMOUNT = R.REDO.AA.PART.DISBURSE.FC<REDO.PDIS.DIS.AMT.TOT>

*DEBUG

        IF A.AMOUNT LE 300000 THEN
            SEL.DET<-1> = SEL.ID
        END

    REPEAT

    CHANGE @FM TO @SM IN SEL.DET
    IF SEL.DET THEN
        ENQ.DATA<2,-1>='@ID'
        ENQ.DATA<3,-1>='EQ'
        ENQ.DATA<4,-1>=SEL.DET
    END
RETURN
END
