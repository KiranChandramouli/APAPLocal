* @ValidationCode : MjoyMTEwMzUyMjUxOkNwMTI1MjoxNjgzODkyNjUzNTk0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.L.AC.STATUS.CODE.PROCESS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to create a table REDO.L.AC.STATUS.CODE.PROCESS
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-11=2010          JEEVA T       ODR-2010-08-0017      Initial Creation
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           FM TO @FM, VM TO @VM,LOOP.CNTR + 1 TO += 1
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*------------------------------------------------------------------------------------------

* ----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.L.AC.STATUS.CODE

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP  = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)



    GET.ACCT.STATUS = R.NEW(REDO.LAC.STAT.L.AC.STATUS)
    TOT.CNTR = DCOUNT(GET.ACCT.STATUS,@VM)

    R.EB.LOOKUP = ''
    CHANGE @VM TO @FM IN GET.ACCT.STATUS

    LOOP.CNTR = 1

    LOOP
    WHILE LOOP.CNTR LE TOT.CNTR

        CURR.ACCT.STATUS = GET.ACCT.STATUS<LOOP.CNTR>
        EB.LOOK.ID = "L.AC.STATUS1*":CURR.ACCT.STATUS
        CALL F.READ(FN.EB.LOOKUP,EB.LOOK.ID,R.EB.LOOKUP,F.EB.LOOKUP,LOOK.ERR)
        IF R.EB.LOOKUP EQ '' THEN
            AF = REDO.LAC.STAT.STATUS.CODE
            ETEXT = "EB-INVALID.LAC.STATUS"
            CALL STORE.END.ERROR
        END
        LOOP.CNTR += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
RETURN
END
