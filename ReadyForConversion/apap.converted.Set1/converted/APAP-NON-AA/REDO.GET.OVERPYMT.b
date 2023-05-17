SUBROUTINE REDO.GET.OVERPYMT(Y.DEAL.VALUE)

*----------------------------------------------------------------------------------------------------------------------
*Description: This routine is call routine from deal slip of AA Payment NV.

*----------------------------------------------------------------------------------------------------------------------
*Input Arg : Y.DEAL.VALUE
*Out Arg   : Y.DEAL.VALUE
*Deals With: AA OVER PAYMENT - WORK AROUND
*----------------------------------------------------------------------------------------------------------------------
* Modification Details:
* =====================
* Date         Who                  Reference         Description
* ------       -----                -----------       -------------
* 08-12-2014   Vignesh Kumaar M R                     INITIAL CREATION
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.COMPANY

    BEGIN CASE
        CASE Y.DEAL.VALUE EQ 'Y.CUR.TIME'
            GET.DATE.TIME = R.NEW(TT.TE.DATE.TIME)

            F1 = GET.DATE.TIME[1,2]
            F2 = GET.DATE.TIME[3,2]
            F3 = GET.DATE.TIME[5,2]
            F4 = GET.DATE.TIME[7,2]
            F5 = GET.DATE.TIME[9,2]

            Y.TIME = F3:'/':F2:'/':F1:'-':F4:':':F5
            Y.DEAL.VALUE = FMT(Y.TIME,"15R")
            RETURN

        CASE Y.DEAL.VALUE EQ 'Y.COMPANY.DETAILS'
            GET.CO.CODE ='APAP':" ":R.COMPANY(EB.COM.COMPANY.NAME):"-":R.NEW(TT.TE.TELLER.ID.1)
            Y.DEAL.VALUE = FMT(GET.CO.CODE,"30R")

            RETURN

    END CASE

RETURN
