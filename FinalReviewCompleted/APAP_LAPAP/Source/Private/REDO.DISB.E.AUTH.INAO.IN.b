* @ValidationCode : MjoxMzkwNzkxOTA6Q3AxMjUyOjE2ODQyMjI4MzAyNzM6SVRTUzotMTotMTozOTk6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 399
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           FM TO @FM, SM TO @SM, INCLUDE TO INSERT
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.DISB.E.AUTH.INAO.IN(ENQ.DATA)

    $INSERT I_EQUATE ;*AUTO R22 CODE CONVERSION - START
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.DISB.CHAIN ;*AUTO R22 CODE CONVERSION - END

    FN.REDO.DISB.CHAIN = 'F.REDO.DISB.CHAIN'; F.REDO.DISB.CHAIN = ''
    CALL OPF(FN.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN)
    FN.REDO.CREATE.ARRANGEMENT = 'F.REDO.CREATE.ARRANGEMENT'; F.REDO.CREATE.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)
*DEBUG
    ID.CC = ID.COMPANY
    SEL.DET = ''; SEL.CMD = ''; SEL.LIST = ''
    SEL.CMD="SELECT ":FN.REDO.DISB.CHAIN:" WITH DISB.STATUS EQ 'AP' AND BRANCH.ID EQ " : ID.CC
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.SLT)
    LOOP
        REMOVE SEL.ID FROM SEL.LIST SETTING SEL.POSN
    WHILE SEL.ID:SEL.POSN
        ERR.REDO.DISB.CHAIN = ''; R.REDO.DISB.CHAIN = ''
        CALL F.READ(FN.REDO.DISB.CHAIN ,SEL.ID,R.REDO.DISB.CHAIN,F.REDO.DISB.CHAIN,ERR.REDO.DISB.CHAIN)
        ARR.ID = R.REDO.DISB.CHAIN<DS.CH.RCA.ID>
        R.REDO.CREATE.ARRANGEMENT = ''; ERR.REDO.CREATE.ARRANGEMENT = ''
        CALL F.READ (FN.REDO.CREATE.ARRANGEMENT,ARR.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.REDO.CREATE.ARRANGEMENT)

        A.AMOUNT = R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.AMT.TOT>

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
