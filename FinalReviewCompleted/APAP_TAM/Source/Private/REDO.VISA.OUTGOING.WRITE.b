* @ValidationCode : MjotMTE5NTYwMjU4NjpDcDEyNTI6MTY4NDg0MjE1MTM4NDpJVFNTOi0xOi0xOjI5MToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 291
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VISA.OUTGOING.WRITE(Y.ID,R.ARRAY)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.VISA.OUTGOING.WRITE
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is write the VISA.OUTGOING with Audit Fields



*IN PARAMETER: Y.ARRAY
*OUT PARAMETER: NA
*LINKED WITH: VISA.SETTLEMENT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*1.12.2010  H GANESH     ODR-2010-08-0469  INITIAL CREATION
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION          TNO TO C$T24.SESSION.NO
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.REDO.VISA.OUTGOING



    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------


    FN.REDO.VISA.OUTGOING='F.REDO.VISA.OUTGOING'
    F.REDO.VISA.OUTGOING=''
    CALL OPF(FN.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING)

    R.ARRAY<VISA.OUT.PROCESS.DATE>=TODAY
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME
    CHECK.DATE = DATE()
    R.ARRAY<VISA.OUT.VISA.CPY.REQ>=''
    R.ARRAY<VISA.OUT.RECORD.STATUS>=''
    R.ARRAY<VISA.OUT.DATE.TIME>=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
    R.ARRAY<VISA.OUT.CURR.NO>=R.ARRAY<VISA.OUT.CURR.NO>+1
    R.ARRAY<VISA.OUT.INPUTTER>=C$T24.SESSION.NO:'_':OPERATOR
    R.ARRAY<VISA.OUT.AUTHORISER>=C$T24.SESSION.NO:'_':OPERATOR
    R.ARRAY<VISA.OUT.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
    R.ARRAY<VISA.OUT.CO.CODE>=ID.COMPANY
*Tus Start
    CALL F.WRITE(FN.REDO.VISA.OUTGOING,Y.ID,R.ARRAY)
    IF NOT(RUNNING.UNDER.BATCH) AND NOT(PGM.VERSION) THEN
        CALL JOURNAL.UPDATE('')
    END
*Tus End

RETURN

END
