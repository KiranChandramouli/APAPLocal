$PACKAGE APAP.TAM
SUBROUTINE REDO.CORRECTION.NAB.ACT.20150512.SELECT

** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.HELPTEXT
    $INSERT I_REDO.CORRECTION.NAB.ACT.20150512.COMMON



    CALL F.READ(FN.HELPTEXT,"REDO.NAB.CORRECTION.20150512-GB",R.HELPTEXT,F.HELPTEXT,HELP.ERR)
    Y.AA.IDS = R.HELPTEXT<EB.HLP.DETAIL>
    CHANGE @SM TO @FM IN Y.AA.IDS
    CHANGE @VM TO @FM IN Y.AA.IDS


    CALL BATCH.BUILD.LIST('', Y.AA.IDS)

RETURN

END
