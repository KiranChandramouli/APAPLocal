* @ValidationCode : MjoxNjU5ODE4ODc1OkNwMTI1MjoxNjgwNjEwMjMzNzQ5OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 17:40:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.UPD.LOCK.ID
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.AUT.UPD.LOCK.ID
*-------------------------------------------------------------------------
* Description: This routine is a ID Routine
*
*----------------------------------------------------------
* Linked with:  AC.LOCKED.EVENTS versions
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE                    ODR                  REFERENCE                            DESCRIPTION
* 21-09-10            ODR-2010-09-0251                                       Initial Creation
*04-04-2023           Conversion Tool          R22 Auto Code conversion      No Changes
*04-04-2023            Samaran T               Manual R22 Code Conversion    No Changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.USER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.CLEARING.OUTWARD

    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

OPEN.FILE:
*Opening Files


    FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.CLEARING.OUTWARD = ''
    CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

RETURN

PROCESS:

*Get the Payment Details

    REDO.CLEAR.OUT.ID = R.NEW(AC.LCK.DESCRIPTION)

* Read REDO.CLEARING.OUTWARD and get the status and raise the override
    IF V$FUNCTION NE 'R' THEN
        CALL F.READU(FN.REDO.CLEARING.OUTWARD,REDO.CLEAR.OUT.ID,R.REDO.OUTWARD.CLEARING,F.REDO.CLEARING.OUTWARD,OUTWARD.ERR,ERR1)
        IF R.REDO.OUTWARD.CLEARING THEN
            R.REDO.OUTWARD.CLEARING<CLEAR.OUT.AC.LOCK.ID,-1> = ID.NEW

*        R.REDO.OUTWARD.CLEARING<CLEAR.OUT.CURR.NO> = R.REDO.OUTWARD.CLEARING<CLEAR.OUT.CURR.NO> + 1

*        R.REDO.OUTWARD.CLEARING<CLEAR.OUT.INPUTTER> = TNO:'_':OPERATOR
*        TEMPTIME = OCONV(TIME(),"MTS")
*        TEMPTIME = TEMPTIME[1,5]
*        CHANGE ':' TO '' IN TEMPTIME
*        CHECK.DATE = DATE()
*        R.REDO.OUTWARD.CLEARING<CLEAR.OUT.DATE.TIME> = OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
*        R.REDO.OUTWARD.CLEARING<CLEAR.OUT.CO.CODE> = ID.COMPANY
*        R.REDO.OUTWARD.CLEARING<CLEAR.OUT.AUTHORISER> =TNO:'_':OPERATOR
*        R.REDO.OUTWARD.CLEARING<CLEAR.OUT.DEPT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
            TEMP.V = V
            V = CLEAR.OUT.AUDIT.DATE.TIME
            CALL F.LIVE.WRITE(FN.REDO.CLEARING.OUTWARD,REDO.CLEAR.OUT.ID,R.REDO.OUTWARD.CLEARING)
            V = TEMP.V
            CALL F.RELEASE(FN.REDO.CLEARING.OUTWARD,REDO.CLEAR.OUT.ID,F.REDO.CLEARING.OUTWARD)
        END ELSE
            CALL F.RELEASE(FN.REDO.CLEARING.OUTWARD,REDO.CLEAR.OUT.ID,F.REDO.CLEARING.OUTWARD)
        END
    END
RETURN
END
