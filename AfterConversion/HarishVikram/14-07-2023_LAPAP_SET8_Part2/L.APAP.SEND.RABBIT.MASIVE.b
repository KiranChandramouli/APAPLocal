* @ValidationCode : MjoxMTY0NjEyNTk1OkNwMTI1MjoxNjg5MzExMjI1MDQwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 14 Jul 2023 10:37:05
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Version 2 02/06/00 GLOBUS Release No. G11.0.00 29/06/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.SEND.RABBIT.MASIVE(APP,VERSION,RECORDID,QUEUEOUT)
*-----------------------------------------------------------------------------
* Modification History

*-----------------------------------------------------------------------------
* Creation: ARCADIO RUIZ
* Creation Date: 2020/05/14
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-07-2023     Conversion tool    R22 Auto conversion       BP Removed
* 13-07-2023     Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_TSS.COMMON
    $INSERT I_F.ST.L.APAP.RABBIT.QUEUE
    $INSERT I_F.DATES


    GOSUB INITIALISE
    GOSUB WRITEQUEUE

RETURN

INITIALISE:


    FN.L.APAP.RABBIT.QUEUE = 'F.ST.L.APAP.RABBIT.QUEUE'
    F.L.APAP.RABBIT.QUEUEE = ''
    CALL OPF(FN.L.APAP.RABBIT.QUEUE, F.L.APAP.RABBIT.QUEUE)

RETURN

WRITEQUEUE:

    Y.MSG<1> = APP : VERSION
    Y.MSG<2> = APP : '>' : RECORDID
    Y.MSG<3> = QUEUEOUT
    Y.DATE = DATE()

    Y.MSG<8> = R.DATES(EB.DAT.TODAY)


    Y.DATE = OCONV(Y.DATE,"DY") : FMT(OCONV(Y.DATE,"DM"),"2'0'R") : FMT(OCONV(Y.DATE,"DD"),"2'0'R")

    Y.TIME = TIME()
    Y.TIME = OCONV(Y.TIME,'MTS')

    CALL ALLOCATE.UNIQUE.TIME(Y.MSG.ID)

    Y.ID.SEQ = EREPLACE(Y.MSG.ID,'.','')
    Y.ID.SEQ = DATE(): Y.ID.SEQ
    Y.MSG.ID = DATE(): Y.MSG.ID

    CALL F.WRITE(FN.L.APAP.RABBIT.QUEUE, Y.MSG.ID, Y.MSG)

RETURN

END
