* @ValidationCode : MjotNDY0NDkzMTg0OkNwMTI1MjoxNjgyNDEyMzMwODA4OkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE  REDO.INP.CHK.CLS.USER
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is restrict the user to open the branch, if he is the one who closed the branch before
*-------------------------------------------------------------------------
*   Date               who            Reference                      Description
*30-MAY-2010     SHANKAR RAJU          PACS00024016                 Initial Creation
*06-04-2023        Conversion Tool     R22 Auto Code conversion      VM TO @VM , ++ TO +=1
*06-04-2023         Samaran T          Manual R22 Code Conversion    No Changes
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.BRANCH.STATUS

    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------
PROCESS:
*~~~~~~~

    NEW.STATUS = R.NEW(BR.ST.OPERATION.STATUS)
    OLD.STATUS = R.OLD(BR.ST.OPERATION.STATUS)

    Y.INPUTTER = R.NEW(BR.ST.INPUTTER)

    Y.INPUTTER.CNT=DCOUNT(Y.INPUTTER,@VM)
    Y.INP.FINAL=''
    Y.VAR3=1
    LOOP
    WHILE Y.VAR3 LE Y.INPUTTER.CNT
        Y.INP=Y.INPUTTER<1,Y.VAR3>
        Y.INP=FIELD(Y.INP,'_',2)
        IF (OLD.STATUS EQ 'CLOSED') AND (NEW.STATUS EQ 'OPEN') THEN
            AF=BR.ST.OPERATION.STATUS
            ETEXT="EB-USER.NEW.OPEN"
            CALL STORE.END.ERROR
        END

        IF (OLD.STATUS EQ 'OPEN') AND (NEW.STATUS EQ 'CLOSED') THEN
            AF=BR.ST.OPERATION.STATUS
            ETEXT="EB-USER.NEW.OPEN"
            CALL STORE.END.ERROR
        END

        Y.VAR3 += 1
    REPEAT
RETURN
END
