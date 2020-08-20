using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;

namespace ArcSoftware.ScavengerHunt.Data.Repo
{
    public interface IRepository
    {
        T GetItem<T>(Expression<Func<T, bool>> predicate, params Expression<Func<T, object>>[] include)
            where T : class;

        IQueryable<T> GetItems<T>(Expression<Func<T, bool>> predicate, params Expression<Func<T, object>>[] include)
            where T : class;

        void Create<T>(T entity) where T : class;

        void CreateMultiple<T>(IEnumerable<T> entities) where T : class;

        void Update<T>(T dbo) where T : class;

        void UpdateMultiple<T>(IEnumerable<T> toUpdate, IEnumerable<T> updated) where T : class;

        void Delete<T>(T entity) where T : class;
    }
}